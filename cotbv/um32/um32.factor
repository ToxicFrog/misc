USING: accessors alien.endian arrays combinators command-line effects.parser formatting io io.mmap kernel math math.bits
math.bitwise memoize namespaces pair-rocket prettyprint sequences specialized-arrays strings vectors ;
IN: um32

USE: specialized-arrays
SPECIALIZED-ARRAY: ube32

TUPLE: UM32
  ! Error state, or "" if operating normally.
  { error string }
  ! How many cycles have we executed?
  { clk fixnum }
  ! Register file. Contains 9 registers. r0 through r7 are general purpose; r8 is the instruction pointer.
  { r array }
  ! Memory banks; vector of vectors of machine words. $0 is initialized with the
  ! program. Others must be allocated at runtime with the ALLOC instruction.
  { mem vector }
  ! Freelist. Dequeue of bank IDs that were allocated but have now been freed
  ! and are available for reuse.
  { freelist dlist }
  ;

: <UM32> ( program -- um32 )
  [ "" 0 { 0 0 0 0 0 0 0 0 0 } ] dip 1vector <dlist> UM32 boa ;

TUPLE: RegisterOp
  { opcode fixnum }
  { a fixnum } { b fixnum } { c fixnum }
  ;

TUPLE: LiteralOp
  { opcode fixnum }
  { a fixnum }
  { val fixnum }
  ;

SYMBOL: *vm*

! Register and memory access words

: get-reg ( vm r -- i ) swap r>> nth ;
: set-reg ( vm i r -- ) rot r>> set-nth ;
: get-ip ( vm -- ip ) 8 get-reg ;
: set-ip ( vm ip -- ) 8 set-reg ;

: get-bank ( vm bank -- mem ) swap mem>> nth ;
: set-bank ( vm mem bank -- ) rot mem>> set-nth ;
:: get-mem ( vm addr bank -- i ) addr vm bank get-bank nth ;
:: set-mem ( vm i addr bank -- ) i addr vm bank get-bank set-nth ;

: halt-vm ( vm reason -- ) >>error drop ;
:: check-ip ( vm -- )
  vm [ 8 get-reg ] [ 0 get-bank length ] bi
  < [ vm "IP out of bounds" halt-vm ] unless ;

! Instruction decoding

:: fetch ( vm -- instr ) vm get-ip [ vm swap 0 get-mem ] [ 1 + vm swap set-ip ] bi ;

: decode-opcode ( instr -- opcode ) 32 <bits> 4 tail* bits>number ;

: decode-abc ( instr -- a b c )
  32 <bits> 3 cut 3 cut 3 head spin [ bits>number ] tri@ ;

: decode-ai ( instr -- a i )
  32 <bits> 25 cut 3 head swap [ bits>number ] bi@ ;

MEMO: decode ( instr -- quot )
  dup decode-opcode
  {
    [ dup 0x0D = ] => [ swap decode-ai LiteralOp boa ]
    [ t ] => [ swap decode-abc RegisterOp boa ]
  } cond
  ;

! Instruction dispatch

! Implements all math of the form: A <- B op C
: (op-math) ( vm op quot -- )
  [ [ a>> ] [ b>> get-reg ] [ c>> get-reg ] 2tri ] dip
  call swap set-reg
  ; inline

:: op-cmov ( vm op -- )  ! A <- B iff C!=0
  op [ c>> vm swap get-reg 0 = ] [ b>> ] [ a>> ] tri
  '[ vm _ get-reg vm swap _ set-reg ] unless ;

:: op-load ( vm op -- )  ! A <- $B:C
  vm
  vm op c>> get-reg
  vm op b>> get-reg
  get-mem
  [ vm ] dip op a>> set-reg ;

:: op-store ( vm op -- )  ! $A:B <- C
  vm dup
  op [ c>> get-reg ] [ b>> get-reg ] [ a>> get-reg ] 2tri
  set-mem ;

: op-add ( vm op -- ) [ math.bitwise:w+ ] (op-math) ;
: op-mul ( vm op -- ) [ math.bitwise:w* ] (op-math) ;
: op-div ( vm op -- ) [ /i ] (op-math) ;
: op-nand ( vm op -- ) [ bitand bitnot 32 math.bitwise:bits ] (op-math) ;

: op-halt ( vm op -- ) drop "halted" halt-vm ;

: (find-free-bank) ( vm -- bankid )
  dup freelist>> deque-empty?
  [ mem>> length ]
  [ freelist>> pop-back ]
  if ;

:: op-alloc ( vm op -- ) ! B <- calloc(C)
  vm op c>> get-reg 0 <array>
  vm (find-free-bank)
  ! mem bank
  [ vm swap op b>> set-reg drop ] [ vm -rot set-bank ] 2bi ;

:: op-free ( vm op -- )  ! free(C)
  vm op c>> get-reg
  [ vm f rot set-bank ]
  [ vm freelist>> push-front ]
  bi ;

: op-out ( vm op -- )  ! putc(C)
  c>> get-reg write1 flush ;

: op-in ( vm op -- )  ! C <- getc()
  c>> read1 swap set-reg ;

:: op-exec ( vm op -- )  ! $0 <- $B; IP <- C
  vm op b>> get-reg dup zero?
  [ drop ] [ [ vm dup ] dip get-bank clone 0 set-bank ] if
  vm dup op c>> get-reg 8 set-reg
  ;

:: op-literal ( vm op -- )  ! A <- val
  vm op val>> op a>> set-reg ;

: dispatch ( vm op -- )
  dup opcode>> {
    0x0 => [ op-cmov ]
    0x1 => [ op-load ]
    0x2 => [ op-store ]
    0x3 => [ op-add ]
    0x4 => [ op-mul ]
    0x5 => [ op-div ]
    0x6 => [ op-nand ]
    0x7 => [ op-halt ]
    0x8 => [ op-alloc ]
    0x9 => [ op-free ]
    0xA => [ op-out ]
    0xB => [ op-in ]
    0xC => [ op-exec ]
    0xD => [ op-literal ]
  } case ;

! VM entry point

USE: prettyprint
:: (show-vm) ( vm -- )
  vm dup 8 get-reg 0 get-mem
  dup decode unparse
  vm
  [ r>> unparse ]
  ! [ mem>> length ]
  [ mem>> 8 index-or-length head [ { } or length ] map unparse ]
  bi "\t0x%08X %s %s %s\n" printf ;

: show-vm ( vm -- )
  drop
!  *vm* get clk>> 50,000,000 rem 0 =
!  (show-vm) flush
! Uncomment these to halt the VM about halfway through sandmark, before the
! profiler crashes.
!  *vm* get clk>> 50,000,000 50 * >
!  [ "timeout" halt-vm ] when
  ;

: run-um32 ( program -- vm )
  <UM32> [
    dup {
      [ show-vm ]
      [ dup fetch decode dispatch ]
      [ check-ip ]
      [ [ 1 + ] change-clk drop ]
      [ error>> empty? ]
    } cleave
  ] loop ;

: dbg ( rom -- )
  [ 0 1430 ] dip subseq [ swap [ 4 * ] dip "%08x: %08x\n" printf ] each-index ;

: run-um32-file ( filename -- vm )
  ube32 [ { } like run-um32 ] with-mapped-array-reader ;

! Invoke as: factor um32.factor sandmark.umz
command-line get first
[ run-um32-file ] profile top-down flat [ profile. ] bi@
! run-um32-file


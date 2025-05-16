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

: >word ( n -- n' ) 0x100000000 rem integer>fixnum ;

: get-reg ( r -- i ) *vm* get r>> nth ;
: set-reg ( i r -- ) [ >word ] dip *vm* get r>> set-nth ;
: get-ip ( -- ip ) 8 get-reg ;
: set-ip ( ip -- ) 8 set-reg ;

: get-bank ( bank -- mem ) *vm* get mem>> nth ;
: set-bank ( mem bank -- ) *vm* get mem>> set-nth ;
: get-mem ( addr bank -- i ) get-bank nth ;
: set-mem ( i addr bank -- ) [ >word ] 2dip get-bank set-nth ;

: halt-vm ( reason -- ) *vm* get error<< ;
: check-ip ( -- ) 8 get-reg 0 get-bank length < [ "IP out of bounds" halt-vm ] unless ;

! Instruction decoding

: fetch ( -- instr ) get-ip [ 0 get-mem ] [ 1 + set-ip ] bi ;

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
: (op-math) ( op quot -- )
  [ [ a>> ] [ b>> get-reg ] [ c>> get-reg ] tri ] dip
  call swap set-reg ; inline

: op-cmov ( op -- )  ! A <- B iff C!=0
  [ c>> get-reg 0 = ] [ b>> ] [ a>> ] tri
  '[ _ get-reg _ set-reg ] unless ;

: op-load ( op -- )  ! A <- $B:C
  [ a>> ] [ c>> get-reg ] [ b>> get-reg ] tri get-mem swap set-reg ;

: op-store ( op -- )  ! $A:B <- C
  [ c>> get-reg ] [ b>> get-reg ] [ a>> get-reg ] tri set-mem ;

: op-add ( op -- ) [ + ] (op-math) ;
: op-mul ( op -- ) [ * ] (op-math) ;
: op-div ( op -- ) [ /i ] (op-math) ;
: op-nand ( op -- ) [ bitand bitnot ] (op-math) ;

: op-halt ( op -- ) drop "halted" halt-vm ;

: (find-free-bank) ( -- bankid )
  *vm* get
  dup freelist>> deque-empty?
  [ mem>> length ]
  [ freelist>> pop-back ]
  if ;

: op-alloc ( op -- ) ! B <- calloc(C)
  [ (find-free-bank) ] dip
  [ c>> get-reg 0 <array> swap set-bank ]
  [ b>> set-reg ]
  2bi ;

: op-free ( op -- )  ! free(C)
  [ f ] dip c>> get-reg
  [ set-bank ]
  [ *vm* get freelist>> push-front ]
  bi ;

: op-out ( op -- )  ! putc(C)
  c>> get-reg write1 flush ;

: op-in ( op -- )  ! C <- getc()
  c>> read1 swap set-reg ;

: op-exec ( op -- )  ! $0 <- $B; IP <- C
  [ b>> get-reg dup zero? [ drop ] [ get-bank clone 0 set-bank ] if ]
  [ c>> get-reg 8 set-reg ]
  bi ;

: op-literal ( op -- )  ! A <- val
  [ val>> ] [ a>> ] bi set-reg ;

: dispatch ( op -- )
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
: (show-vm) ( -- )
  8 get-reg 0 get-mem
  dup decode unparse
  *vm* get
  [ r>> unparse ]
  [ mem>> length ]
  [ mem>> 8 index-or-length head [ { } or length ] map unparse ]
  tri "\t0x%08X %s %s %d %s\n" printf ;

: show-vm ( -- )
  *vm* get clk>> 50,000,000 rem 0 =
  [ (show-vm) flush ] when
! Uncomment these to halt the VM about halfway through sandmark, before the
! profiler crashes.
!  *vm* get clk>> 50,000,000 50 * >
!  [ "timeout" halt-vm ] when
  ;

: with-um32 ( um32 quot -- ... )
  *vm* swap with-variable ; inline

: run-um32 ( program -- vm )
  <UM32> [
    [ show-vm
      fetch decode dispatch check-ip
      *vm* get
      [ [ 1 + ] change-clk drop ]
      [ error>> empty? ] bi ]
    loop *vm* get
  ] with-um32 ;

: dbg ( rom -- )
  [ 0 1430 ] dip subseq [ swap [ 4 * ] dip "%08x: %08x\n" printf ] each-index ;

: run-um32-file ( filename -- vm )
  ube32 [ { } like run-um32 ] with-mapped-array-reader ;

! Invoke as: factor um32.factor sandmark.umz
command-line get first
[ run-um32-file ] profile top-down flat [ profile. ] bi@
! run-um32-file


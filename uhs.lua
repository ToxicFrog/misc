cipher = "`J CtIyJ& pFF |wz yDwzFB {wII| pAwzJ ty rLHFwItGs'  lwzSFF BtyqwKrI {DpJ |wzI swpF ty py JDr spvr HIwsIryyry' :2_6uj3k9"
clear =  "At first, all you should worry about is exploring.  You'll discover what your goal is as the game progresses. TD?LkUFWR"

tr = {}

for i=1,#cipher do
  cipherchar = cipher:sub(i,i)
  clearchar = clear:sub(i,i)

  assert(not tr[cipherchar] or tr[cipherchar] == clearchar)
  tr[cipherchar] = clearchar
end

for line in io.lines() do
  print((line:gsub(".", tr)))
end

local digits,target = "264770140", -58
-- local digits, target = "101", 2

local function tail(digits)
  return digits:sub(2)
end

local function log(depth, msg, ...)
  do return end
  return print((" "):rep(depth)..msg, ...)
end

local function permute(digits, depth)
  depth = depth or 0
  return coroutine.wrap(function()
    log(depth, "permute", digits)
    if #digits <= 1 then coroutine.yield(digits); return; end
    for rest in permute(tail(digits), depth+1) do
      log(depth, "rest", "'"..rest.."'")
      for _,op in ipairs { "", "+", "-", "*" } do
        log(depth, "op", op, rest:sub(1,1) ~= "0")
        if not rest:match("^0%d") or op == "" then
          log(depth, "yield!", digits:sub(1,1) .. op .. rest)
          coroutine.yield(digits:sub(1,1) .. op .. rest)
        end
      end
    end
  end)
end

local function solve(data)
  local digits = data[0]
  local target = data[1]
  local answer = js.new(js.global.Array)

  for expr in permute(digits) do
    local res = load("return "..expr)()
    if res == target then
      answer:push(expr)
    end
  end
  return answer
end

return solve

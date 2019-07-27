local log = require 'log'

local function tail(digits)
  return digits:sub(2)
end

local function permute(digits)
  return coroutine.wrap(function()
    if #digits <= 1 then coroutine.yield(digits); return; end
    for rest in permute(tail(digits)) do
      for _,op in ipairs { "", "+", "-", "*" } do
        if not rest:match("^0%d") or op == "" then
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
  log.info("Found %d answers", answer.length)

  return answer
end

return solve

local function dfs(pair, index, left, right, s, solution, res)
  if #s < index then
    if left == 0 and right == 0 and pair == 0 then
        res[solution] = true
    end
    return
  end
  if s(index,index) == '(' then
    if left > 0 then
      dfs(pair, index+1, left-1, right, s, solution, res)
    end
    dfs(pair+1, index+1, left, right, s, solution .. s(index,index), res)
  elseif s(index,index) == ')' then
    if right > 0 then dfs(pair, index+1, left, right-1, s, solution, res) end
    if pair > 0 then dfs(pair-1, index+1, left, right, s, solution .. s(index,index), res) end
  else
    dfs(pair, index+1, left, right, s, solution .. s(index,index), res)
  end
end

local function solve(data)
  local res = {}
  local left,right = 0,0
  for char in data:gmatch'.' do
    if char == '(' then
      left = left+1
    elseif char == ')' then
      if left > 0 then left = left-1 else right = right+1 end
    end
  end
  dfs(0, 1, left, right, data, "", res)
  local answer = js.Array {}
  for solution in pairs(res) do
    answer:push(solution)
  end
  return answer
end

return solve

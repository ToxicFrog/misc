-- Send a shell command passed in argv to the terminal.

local shell = {}

function shell.execute(...)
  local command = table.concat({...}, " ")

  ns:sleep(1)
  local input = js.global.document:getElementById("terminal-input-text-box")
  input.value = command
  input:dispatchEvent(js.new(
    js.global.KeyboardEvent,
    "keydown",
    js.Object { bubbles = true; cancelable = true; keyCode = 13; }
  ))
  ns:sleep(1)
end

return shell

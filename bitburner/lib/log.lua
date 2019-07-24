ns:disableLog 'ALL'

local levels = {
  "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"
}; for k,v in pairs(levels) do levels[v] = k end
local log_level = "INFO"
local tty_level = "ERROR"

local function logger(level, depth)
  return function(fmt, ...)
    local info,prefix
    if levels[level] >= levels[log_level] then
      info = debug.getinfo(2, "Sl")
      prefix = string.format("%1.1s %s:%d]  ",
        level, info.short_src:gsub(".lua.txt$",""):gsub("^/.*/",""), info.currentline)
      ns:print(prefix..fmt:format(...))
    end
    if levels[level] >= levels[tty_level] then
      info = info or debug.getinfo(2, "Sl")
      prefix = prefix or string.format("%1.1s %s:%d]  ",
        level, info.short_src:gsub(".lua.txt$",""):gsub("^/.*/",""), info.currentline)
      ns:tprint(prefix..fmt:format(...))
    end
    if level == "FATAL" then ns:exit() end
  end
end

local function setlevel(log, tty)
  log_level,tty_level = log:upper(),tty:upper()
end

local function getlevel()
  return log_level,tty_level
end

return {
  setlevel = setlevel;
  getlevel = getlevel;
  trace = logger "TRACE";
  debug = logger "DEBUG";
  info = logger "INFO";
  warn = logger "WARN";
  error = logger "ERROR";
  fatal = logger "FATAL";
}

local fd = io.open('sheet.html', 'wb')
fd:write [[
  <html>
   <head>
    <link rel="stylesheet" href="./sheet.css">
   </head>
   <body>
]]

function emit(...)
  fd:write(string.format(...).."\n")
end

function pbreak()
  emit '<P style="page-break-before: always" class="pbreak-after" />'
end

function open(title)
  return function(n)
    emit('<table><tr><th colspan=%d>%s</th></tr>', n, title)
  end
end

function close()
  emit('</table>')
end

function row(content)
  emit('<tr>')
  for _,cell in ipairs(content) do
    emit("%s", cell)
  end
  emit('</tr>')
end

function string:count(pattern)
  local n = 0
  for _ in self:gmatch(pattern) do n=n+1 end
  return n
end

function subtable(title)
  local _emit = emit
  local buf = {}
  function emit(...) table.insert(buf, string.format(...)) end
  return function(n)
    return function(rows)
      tbl(title)(n)(rows)
      buf = '<td class="subtable">'..table.concat(buf, '\n')..'</td>'
      emit = _emit
      return buf
    end
  end
end

function tbl(title)
  return function(n)
    open(title)(n)
    return function(rows)
      local buf = ""
      for _,r in ipairs(rows) do
        buf = buf..r
        -- print("ROW", buf:count('<td'), r)
        if buf:count('<td') >= n or buf:match('colspan=') then
          row{buf}
          buf = ""
        end
      end
      if #buf > 0 then row{buf} end
      close()
    end
  end
end

function txt(text, span)
  local tag
  if span then
    tag = '<td class="text" colspan="'..span..'">'
  else
    tag = '<td class="text">'
  end
  return tag..(text
    :gsub("^%s+","")
    :gsub("%s+$","")
    :gsub("\n", "<br>")
    :gsub("_([^*]-)_", "<u>%1</u>")
    -- :gsub("/([^/]-)/", "<i>%1</i>")
    :gsub("%*([^*]-)%*", "<b>%1</b>"))..'</td>'
end

function txtspan(n)
  return function(text) return txt(text, n) end
end

function score(score, span)
  return function(text)
    return '<td class="score">'..(score
      :gsub("^%s+","")
      :gsub("%s+$","")
      :gsub("\n", "<br>")
      :gsub("_([^*]-)_", "<u>%1</u>")
      :gsub("%*([^*]-)%*", "<b>%1</b>"))..'</td>'
      .. txt(text, span)
  end
end

function subheader(text)
  return string.format('<tr><th colspan=99>%s</th></tr>', text)
end

function scorespan(n)
  return function(pts) return function(text) return score(pts, n)(text) end end
end

function tiles(text)
  return '<td class="tiles">'..(text
    :gsub("^%s+","")
    :gsub("%s+$","")
    :gsub(" *(%S+) *",'<img src="%1.gif">')
    :gsub("\n", "<br>"))..'</td>'
end

function cells(c)
  buf = ""
  for _,text in ipairs(c) do
    buf = buf..txt(text)
  end
  return buf
end


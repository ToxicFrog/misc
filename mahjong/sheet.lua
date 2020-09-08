local fd = io.open('sheet.html', 'wb')
fd:write [[
  <html>
   <head>
    <link rel="stylesheet" href="./sheet.css">
   </head>
   <body>
]]

local function emit(...)
  fd:write(string.format(...).."\n")
end

local function pbreak()
  emit '<P style="page-break-before: always"/>'
end

local function open(title)
  return function(n)
    emit('<table><tr><th colspan=%d>%s</th></tr>', n, title)
  end
end

local function close()
  emit('</table>')
end

local function row(content)
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

local function tbl(title)
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

local function txt(text)
  return '<td class="text">'..(text
    :gsub("^%s+","")
    :gsub("%s+$","")
    :gsub("\n", "<br>")
    :gsub("_([^*]-)_", "<u>%1</u>")
    :gsub("%*([^*]-)%*", "<b>%1</b>"))..'</td>'
end

local function score(score)
  return function(text)
    return '<td class="score">'..(score
      :gsub("^%s+","")
      :gsub("%s+$","")
      :gsub("\n", "<br>")
      :gsub("_([^*]-)_", "<u>%1</u>")
      :gsub("%*([^*]-)%*", "<b>%1</b>"))..'</td>'
      .. txt(text)
  end
end

local function tiles(text)
  return '<td class="tiles">'..(text
    :gsub("^%s+","")
    :gsub("%s+$","")
    :gsub(" *(%S+) *",'<img src="%1.gif">')
    :gsub("\n", "<br>"))..'</td>'
end

local function cells(c)
  buf = ""
  for _,text in ipairs(c) do
    buf = buf..txt(text)
  end
  return buf
end

emit('<div style="text-align: center; width=0%%; margin:0px;">')

open "Tile Types" (4)
row {
  tiles "c2\nb4\nd7",
  txt [[
    *Suits* — Characters, Bamboo, and Circles/Orbs<hr>Used to form chows, pungs, and kongs.
  ]],
  tiles "spring flower-summer\nfall flower-winter",
  txt [[
    *Bonuses* — Seasons and Flowers<hr>When drawn, set aside and draw a replacement.
  ]]
}
row {
  tiles "red\ngreen\nwhite",
  txt [[
    *Dragon Honours* — Red, Green, and White<hr>Can form pungs and kongs, but not chows.
  ]],
  tiles "E S\nW N",
  txt [[
    *Wind Honours* — East, South, West, and North<hr>Can form pungs and kongs, but not chows. Bonus if it matches the round wind or your seat wind.
  ]]
}
close()

open "Basic Groups" (2)
row {
  tiles [[
    d1 d2 d3
    c4 c5 c6
    b7 b8 b9
  ]],
  txt [[
    *Chow* (three in a row)
    _Concealed_: form in your hand using tiles from the wall.
    _Revealed_: take the preceding player's discard, immediately combine with two tiles in your hand, and play face up.
    Form from suits only; dragons and winds cannot chow.
  ]],
}
row {
  tiles [[
    b2 b2 b2
    green green green
    S S S
  ]],
  txt [[
    *Pung* (three of a kind)
    _Concealed_: form in your hand using tiles from the wall.
    _Revealed_: take *any* player's discard, immediately combine with two tiles in your hand, and play face up.
    If you take another player's discard, play continues to your right even if this skips some players.
  ]]
}
row {
  tiles [[
    d3 d3
    d3 d3
    E E
    E E
  ]];
  txt [[
    *Kong* (four of a kind)
    _Concealed_: form in your hand using tiles from the wall. Declare and play face down (now or later).
    _Revealed (Small)_: take a tile from your hand and add it to a revealed pung.
    _Revealed (Large)_: take *any* player's discard and immediately add it to a concealed pung; play face up.
    After playing any kong, draw a _replacement tile_ from the back of the wall and proceed as if you had just drawn from the wall at the start of your turn.
  ]]
}
row {
  tiles [[
    d1 d1 d1
    c4 c4 c4
    b3 b4 b5
    red red red
    red N N
  ]];
  txt [[
    *Mahjong* (winning hand)
    Any four basic groups + any pair. Ends the game immediately in victory for you.
    If you need only one tile to form mahjong, you can steal it from any player's discard as if forming a pung, even if it would be used to form a chow or pair. You can also form it by stealing the tile another player plays from their hand to form a small revealed kong.
  ]]
}
close()

pbreak()

--[=[
open "Alternate Wins" (3)
row {
  score "6";
  tiles [[
    spring summer fall winter
    flower-spring flower-summer flower-fall flower-winter]];
  txt [[
    *Nature's Bounty*
    All flowers and seasons.
    If you have seven of the requisite tiles, you can steal the 8th if another player plays it (but not if they already have it);
  ]];
}
row {
  score "8";
  tiles [[
    red green white E S W N
    b1 b9 c1 c9 d1 d9 back]];
  txt [[
    *The Thirteen Orphans*
    One each of the 1 and 9 of each suit and one of each honour, plus any 14th tile.
  ]];
}
row {
  score "8"; txt""; txt [[
    *The Blessing of Heaven*: dealer wins with initial hand
    *The Blessing of Earth*: any other player wins with initial hand
  ]];
}
close()
]=]

tbl "Alternate Wins" (4) {
  score "6" [[
    *Nature's Bounty*: one of each flower and season
    If you already have seven, you can steal the 8th when someone else draws it.
  ]];
  score "8" [[
    *The Thirteen Orphans*: one of each honour + the 1 and 9 of each suit.
  ]];
  [[
    <td class="score"two>8</td>
    <td colspan=3>
      <b>The Blessing of Heaven</b>: dealer wins with initial hand<br>
      <b>The Blessing of Earth</b>: any other player wins with intial hand
    </td>]];
  '<th colspan=4>Victory Bonuses</th>';
  score "+1" "Win by drawing a tile";
  --[[
    Win by drawing from the wall.
    +1 if it's the last tile.
    Another +3 if it's the last tile *and* it's 1 Orb.
  ]]
  score "+2" "Win using the last discard of the game.";
  score "+1" "Win by stealing the tile another player uses to form a small kong.";
  score "+2" "Win using the replacement tile you draw after declaring kong.";
  --[[
    Win using the replacement tile you draw after declaring kong.
    +3 if you did more than one kong this turn before winning.
    +3 if the tile is 5 Orb and you use it to complete a 4-5-6 Orb chow.
  ]]
  '<th colspan=4>Hand Bonuses</th>';
-- }

-- tbl "Hand Bonuses" (4) {
  score "+1" "Whole hand is concealed, some chows";
  score "+1" "All chows, no honours";
  score "+3" "All pungs, some revealed";
  score "+3" "*Half Flush*: one suit + honours";
  score "+6" "*Full Flush*: one suit, no honours";
  score "+8" "Honour tiles only";
  score "+8" "Four concealed pungs";
  txt ''; txt '';

  '<th colspan=4>Group Bonuses</th>';
  score "+1" "Pung of round wind";
  score "+1" "Pung of seat wind";
  score "+6" "three pungs + pair of winds";
  score "+8" "*Great Winds*: four pungs of winds";
  score "+1" "At least one pung of dragons";
  score "+3" "two pungs + pair of dragons";
  score "+6" "*Great Dragons*: three pungs of dragons";
  txt ""; txt "";
  score "+1" "No flower tiles";
  score "+1" "Per flower or season tile";
  score "+1" "Per flower or season of the round";
  score "+1" "Per flower or season of your seat";
}

tbl "Scoring" (16) {
  [[
  <td colspan=16>All bonuses are given in <i>fan</i>. Before playing you should agree on a minimum fan to declare victory (typically 3) and a maximum fan per round (typically 10-13). After tallying bonuses, consult the fan→points table below to determine actual score.<br>
  Typically, if you win from the wall all other players pay you your score; if you win from discard, the discarding player pays double and the other players pay half or nothing.
  </td>]];
  cells { "Fan", "0", "1", "2", "3", "4", "5", '6', '7', '8', '9', '10', '11', '12', '13', '14' };
  cells { 'Points', '2', '4', '8', '16', '32', '48', '64', '96', '128', '192', '256', '384', '512', '768', '1024' };
  '<th colspan=16>Two/Three Player Game</th>';
  [[<td colspan=16>
  For a <u>three-player game</u>, remove the 2-8 of characters, or disallow chow of characters.<br>
  For a <u>simple two-player game</u>, disallow chow entirely and otherwise play normally.<br>
  For <u>more complexity</u>, give each player two hands; you can move tiles between them at will but must go mahjong with both to win, and can't swap tiles once they are revealed. At end of game subtract loser's score (if they have a mahjong out) from winner's.
  </td>]];
}

emit [[
  </div>
  </body>
</html>
]]

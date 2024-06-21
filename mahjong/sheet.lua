require 'lib'

emit('<div style="text-align: center; width=0%%; margin:0px;">')

open "Overview" (1)
row {
  txt [[
    A game of Mahjong is played in multiple *rounds*, with each round consisting of several *hands*. The overall goal of the game is to score the most points; the goal of each hand is to form a *winning hand* of tiles before anyone else does. Most winning hands will consist of four *melds* (chows, pungs, or kongs) and one matched pair of tiles, but how many points a winning hand is worth depends on what's in it and how it was built.

    These rules are based on one particular version of Hong Kong Old Style Mahjong, but there are innumerable variants of the game, with different tiles, scoring rules, and even rules of play. Feel free to tweak these rules to make it more fun; just make sure everyone in the group agrees what rules you are playing with before you start!
  ]]
}

open "Tile Types" (4)
row {
  tiles "d7 b4\nc1 c9",
  txt [[
    *Suits* — Circles, Bamboo, and Hanzi.<hr>The 1 and 9 of each suit are called the "terminals".
  ]],
  tiles "spring flower-summer\nfall flower-winter",
  txt [[
    *Bonuses* — Seasons and Flowers<hr>Grants extra points if you collect the right ones.<br>When drawn, play immediately and draw a replacement.
  ]]
}
row {
  tiles "red green\nwhite",
  txt [[
    *Dragons* — Red, Green, and White<hr>All types of dragons are "honour tiles" and grant extra points.
  ]],
  tiles "E S\nW N",
  txt [[
    *Winds* — East, South, West, and North<hr>All winds are "honour tiles", but only the ones matching the round wind or your seat wind grant extra points.
  ]]
}
close()

open "Chow (three in a row)" (2)
row {
  tiles [[
    d1 d2 d3
    b7 b8 b9
  ]],
  txt [[
    _Closed_: form in your hand using tiles from the wall.
    _Open_: form face-up by stealing the preceding player's discard and combining with two tiles in your hand.
    <hr>Formed from suits only, not honour tiles. Usually the lowest-scoring form of meld.
  ]],
}
close()

open "Pung (three of a kind)" (2)
row {
  tiles [[
    b2 b2 b2
    S S S
  ]],
  txt [[
    _Closed_: form in your hand using tiles from the wall.
    _Open_: form face-up by stealing *any* player's discard and combining with two tiles in your hand.
    <hr>Play continues to your right even if this skips someone.
  ]]
}
close()

open "Kong (four of a kind)" (2)
row {
  tiles [[
    back E E back
    d3 d3 d3 d3
  ]];
  txt [[
    _Closed_: form in your hand using tiles from the wall, then play partially face up.
    _Open (Small)_: form face-up by adding a tile from the wall to a revealed pung.
    _Open (Large)_: form face-up by stealing *any* player's discard and adding to a concealed pung.
    <hr>After playing, draw a replacement. Play continues to your right as with pung.
  ]]
}
close()

open "Play" (2)
row {
  txt "*Your Turn*"; txt "Draw a tile, then choose a tile to discard (or declare victory if you can). You always end your turn by discarding, whether you drew a tile from the wall or stole a tile from someone else.";
}
row {
  txt "*Stealing*"; txt "After someone discards, other players have a few seconds to steal that tile to complete a meld or a winning hand. If multiple players try to steal at once, winning beats kong, which beats pung, which beats chow. Note that you can always steal if that tile would give you a winning hand, even if it wouldn't complete a meld.";
}
row {
  txt "*Replacements*"; txt "After playing a bonus tile or a kong, draw a replacement tile from the back of the dead dead wall rather than the front of the live wall."
}
row {
  txt "*Dead Wall*"; txt "The last 14 tiles of the wall (7 columns) are the \"dead wall\". It's always 14 tiles long no matter how many tiles you've drawn from it."
}
row {
  txt "*Out of Tiles*"; txt "The hand ends in a 4-way tie if there are only 14 tiles (the dead wall) left on the table.";
}
row {
  txt "*Winning*"; txt "When drawing or stealing a tile gives you a winning hand (4 melds + 1 pair), reveal your hand and declare victory. You score points from the other players depending on the contents of the hand."
}
row {
  txt "*Next Hand*"; txt "At the end of a hand (unless it was a tie), the East position moves to the player to the current East's right, and that player goes first."
}
row {
  txt "*Next Round*"; txt "Once every player has been East, the round wind changes to South and the South player goes first. After that comes West, then North."
}
row {
  txt "*Game End*"; txt "A game usually ends after 1-4 rounds (depending on how long a game people want). It also ends immediately if any player runs out of points completely.";
}
close()

pbreak()

open "Setup" (1)
row {
  txt [[
    (1) Choose a player to be East. Seat players counterclockwise E-S-W-N (reverse compass order). Decide on scoring rules.
    (2) Shuffle tiles and build four walls, each one 18 tiles wide and 2 high. Push them together into a square.
    (3) East rolls 3d6; count that many seats around the table. That player counts that many tiles from the edge of their wall and breaks the wall there. Players will draw tiles from the right side of the break.
    (4) Players draw two tiles at a time, starting with East, until everyone has 12 tiles; then one more tile each to make 13.
    (5) The round wind always starts at East, so the East player gets the first turn.
  ]]
}
close()

open "Between Hands" (1)
row {
  txt [[
    If a hand ends in a tie, just reshuffle the tiles, rebuild the walls, and play another hand.
    If someone won, but not everyone has been the first player yet this round, the *seat winds* change; the player after the current East becomes the new East (with the players after them being South, West, and North).
    If everyone has already been first player this round, the *round wind* changes instead, in the same order: East➞South➞West➞North. The player whose seat matches the new round wind goes first.
  ]]
}
close()

tbl "Scoring" (1) {
  row {
    txt [[
      Players start with 500 *points*. The overall winner is the one with the most points at the end of the game.
      Hands are scored in *faan*. Before playing, players should agree on a minimum number of faan to declare victory (usually 1-3) and a maximum faan per hand (usually 7 or 10; sometimes 13).
      When someone wins a hand, the other players give them points based on the faan-to-points table below. If they won by stealing a tile from someone, the person they stole it from pays double. If they won by drawing a tile, *everyone* pays double.
    ]];
  };
  row {
    subtable "Faan to Points" (9) {
      cells { "Faan", '0', '1', '2', '3', '4-6', '7-9', '10-12', '13+' };
      cells { 'Points', '1', '2', '4', '8', '16', '32', '64', '128' };
      -- cells { 'Points', '600', '800', '1,000', '2,000', '4,000', '8,000', '12,000', '16,000', };
    };
  };
  -- row {
  --   subtable "Faan to Points" (9) {
  --     cells { "Faan", '0', '1', '2', '3', '4-6', '7-9', '10-12', '13+' };
  --     cells { 'Points', '600', '800', '1,000', '2,000', '4,000', '8,000', '12,000', '16,000', };
  --   };
    -- txt [[
    --   <b>2</b>: points; <b>(2)</b>: points with open hand; <b>(-)</b>: not valid with open hand. Anything that needs a pung also works with a kong.
    -- ]]
  -- };
  -- row {
  --   txt [[
  --     The tables below show the various faan bonuses. Ones listed as "max" automatically score the maximum faan possible.
  --   ]]
  -- }
}

--[[
tbl "Faan from Winning Hand" (4) {
  score "0" "Basic Mahjong (4 melds + 1 pair)";
  score "4" "Seven Pairs (7 matched pairs of tiles, no melds)";
  scorespan(3) "max" "Nature's Bounty (all 8 bonus tiles, main hand doesn't matter)";
  scorespan(3) "max" "Thirteen Orphans (one of each honour and terminal + one duplicate)";
--}

--tbl "Faan from Winning Move" (4) {
subheader "Faan from Winning Move";
  score "2" "Draw last tile from wall";
  score "1" "Steal from small open kong";
  score "1" "Draw from wall";
  score "1" "Steal the last discard of the game";
  score "1" "Draw from dead wall";
  score "0" "Steal anything else";
  scorespan(3) "max" "Blessing of Heaven/Earth (win with your first draw of the hand)";

subheader "Faan from Bonuses";
  score "2" "All seasons";
  score "2" "All flowers";
  score "1" "Season of your seat";
  score "1" "Flower of your seat";
  score "1" "No bonus tiles at all";
  score "max" "All 8 bonus tiles (automatic win)";

subheader "Faan from Melds";
  score "3" "All pungs/kongs (open hand)";
  score "1" "All chows (closed hand)";
  score "6" "All pungs/kongs (closed hand)";
  score "max" "All kongs";

subheader "Faan from Honours";
  score "1" "Pung/kong of round wind";
  score "1" "For each pung/kong of dragons";
  score "1" "Pung/kong of seat wind";
  score "1" "*All Simples*: No honours or terminals";
  score "4" "*Small Dragons*: two pungs/kongs + pair of dragons";
  score "8" "*Small Winds*: three pungs/kongs + pair of winds";
  score "6" "*Big Dragons*: three pungs/kongs of dragons";
  score "max" "*Big Winds*: four pungs/kongs of winds";
  score "8" "*All Honours*: Entire hand is honour tiles";

subheader "Faan from Suits";
  score "3" "*Half Flush*: one suit with some honour tiles";
  score "6" "*Full Flush*: one suit with no honour tiles";
  scorespan(3) "max" "*Pearl Dragon*: all pungs/kongs, mix of circles and white dragon tiles";
  scorespan(3) "max" "*Jade Dragon*: all pungs/kongs, mix of bamboo and green dragon tiles";
  scorespan(3) "max" "*Ruby Dragon*: all pungs/kongs, mix of characters and red dragon tiles";
  scorespan(3) "max" "*Nine Gates*: 1112345678999 of one suit + one extra of the same suit (closed hand)";
}
pbreak()
]]

tbl "Score Table" (4) {
  -- score '2' '2 faan';
  -- score '2 (1)' '2 faan with closed hand, 1 faan with open';
  -- score '2 (-)' '2 faan with closed hand, 0 faan with open';
  -- score 'max' 'Automatically score the maximum faan';
  scorespan(3) 'Notes' "*2 (1)* means that bonus is worth 2 if closed, 1 if open. *2 (-)* means you only get the bonus if the hand is closed. *max* means it automatically scores maximum faan. Anything that needs a pung, you can also use kongs for.";

  subheader 'Alternate Winning Hands';
    score 'max' 'Thirteen Orphans';
    score 'max' 'Nine Gates';
    score 'max' 'Eight Treasures';
    score '2' 'Seven Pairs';

  subheader 'Faan from Winning Move';
    score 'max' 'Win with your first draw';
    score '1' 'Last draw from the wall';
    score '1' 'Steal the last discard';
    score '1' 'Any draw from the dead wall';
    score '1' 'Steal from a small kong';
    score '1 (-)' 'Normal draw from the wall';


  subheader "Faan from Bonuses";
    score "2" "All seasons";
    score '1' 'Per season or flower of your seat';
    score '2' 'All flowers';
    score "1" "No bonus tiles at all";

  subheader 'Faan from Suits';
    score '6 (5)' '*Full Flush* All one suit, no honours';
    score '2 (1)' '*Pure Straight* 1-9 of one suit';
    score '3 (2)' '*Half Flush* All one suit, some honours';
    score '2 (1)' 'Three matching chow of different suits';
    score '3 (-)' 'Two sets of two matching chow of one suit';
    score '1 (-)' 'Two matching chow of one suit';

  subheader 'Faan from Melds';
    score 'max' 'Four kongs';
    score '2' 'Three kongs';
    score 'max (2)' 'Four pungs';
    score '2' 'Three closed pungs';
    score '2' 'Three pungs with the same number';
    score '2' '2 pungs + 1 pair of dragons';

  subheader 'Faan from Honours/Terminals';
    scorespan(3) 'max' 'Three wind pungs + wind pair or pung';
    score 'max' 'Three dragon pungs';
    score '2' 'Two dragon pungs + dragon pair';
    score 'max' 'Only honours';
    score '1' '*All Simples* No honours or terminals';
    score 'max' 'Only terminals';
    score '1' 'One dragon pung';
    score '3 (2)' 'At least one terminal in each meld';
    score '1' 'Prevalent wind';
    score '2' 'Only terminals and honours';
    score '1' 'Seat wind';
}

emit [[
  </div>
  </body>
</html>
]]

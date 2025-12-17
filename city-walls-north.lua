region 'City Walls North' {
  room 'From Squire to Knight' {
    nw 'Rue Lejour'; -- to Town Centre East
    s 'Traces of Invasion Past' 'Iron Key';
    n 'Be for Battle Prepared';
    enemy 'Blood Lizard';
  };
  room 'Traces of Invasion Past' {
    n 'From Squire to Knight';
    s 'A Knight Sells his Sword'; -- to Undercity East
    enemy 'Dark Elemental';
  };
  room 'Be for Battle Prepared' {
    s 'From Squire to Knight';
    n 'Destruction and Rebirth';
    enemy 'Blood Lizard';
  };
  room 'Destruction and Rebirth' {
    s 'Be for Battle Prepared';
    n 'From Boy to Hero';
    enemy 'Dark Elemental';
  };
  room 'From Boy to Hero' {
    sw 'Kesch Bridge'; -- to Town Centre East
    s 'Destruction and Rebirth';
    n 'A Welcome Invasion' 'Iron Key';
    enemy 'Blood Lizard';
    dummy 'Phantom' { after = 'Dark Abhors Light' };
  };
  room 'A Welcome Invasion' {
    s 'From Boy to Hero';
    n 'The Greengrocer\'s Stair'; -- to Undercity East
    enemy 'Dark Elemental';
  };
}

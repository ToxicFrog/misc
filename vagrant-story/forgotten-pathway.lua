region 'Forgotten Pathway' {
  room 'Stair to the Sinners' {
    s "The Soldier's Bedding"; dy=2; -- to The Keep
    n 'Slaugher of the Innocent';
  };
  -- N.b. this typo is in the original game
  room 'Slaugher of the Innocent' {
    s 'Stair to the Sinners';
    n 'The Oracle Sins No More';
    enemy 'Damascus Golem' {
      miniboss = true;
      'Cure Tonic x3'
    }
  };
  room 'The Oracle Sins No More' {
    s 'Slaugher of the Innocent';
    w 'The Fallen Knight';
    e 'Awaiting Retribution';
    trap 'Curse Panel';
    trap 'Holy Light';
    enemy 'Blood Lizard';
  };
  room 'The Fallen Knight' {
    e 'The Oracle Sins No More';
    enemy 'Blood Lizard';
    enemy 'Imp';
    chest { 'Kadesh Ring', 'Orlandu', 'Elixir of Queens', 'Steel Key' }
  };
  room 'Awaiting Retribution' {
    w 'The Oracle Sins No More';
    enemy 'Blood Lizard';
    enemy 'Imp';
    chest { 'Diadra\'s Earring', 'Ogmius', 'Elixir of Queens' }
  };
}

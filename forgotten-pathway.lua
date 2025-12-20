region 'Forgotten Pathway' {
  -- TODO: add enemies, chests
  room 'Stair to the Sinners' {
    s "The Soldier's Bedding"; dy=2; -- to The Keep
    n 'Slaughter of the Innocent';
  };
  room 'Slaughter of the Innocent' {
    s 'Stair to the Sinners';
    n 'The Oracle Sins No More';
  };
  room 'The Oracle Sins No More' {
    s 'Slaughter of the Innocent';
    w 'The Fallen Knight';
    e 'Awaiting Retribution';
  };
  room 'The Fallen Knight' {
    e 'The Oracle Sins No More';
  };
  room 'Awaiting Retribution' {
    w 'The Oracle Sins No More';
  };
}

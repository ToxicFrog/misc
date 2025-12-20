region 'Escapeway' {
  -- TODO: add chests and enemies
  'Not to be confused with the individual room named Escapeway.';
  room 'Shelter From the Quake' {
    n 'Path of the Children'; dx=-0.5; dy=0.5; -- to Undercity West
    w 'Buried Alive' 'Gold Key';
    e 'Movement of Fear';
    s 'Fear and Loathing';
  };
  room 'Buried Alive' {
    e 'Shelter From the Quake';
  };
  room 'Movement of Fear' {
    w 'Shelter From the Quake';
    n 'Facing Your Illusions';
  };
  room 'Facing Your Illusions' {
    s 'Movement of Fear';
    e 'The Darkness Drinks';
  };
  room 'The Darkness Drinks' {
    w 'Facing Your Illusions';
    s 'Where Flood Waters Ran';
  };
  room 'Fear and Loathing' {
    n 'Shelter From the Quake';
    s 'Blood and The Beast';
  };
  room 'Blood and The Beast' {
    n 'Fear and Loathing';
    w 'Where Body and Soul Part';
  };
  room 'Where Body and Soul Part' {
    e 'Blood and The Beast';
  };
}

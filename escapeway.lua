region 'Escapeway' {
  'Not to be confused with the individual room named Escapeway.';
  room 'Shelter From the Quake' {
    n 'Path of the Children'; dx=-0.5; dy=0.5; -- to Undercity West
    w 'Buried Alive' 'Gold Key';
    e 'Movement of Fear' 'Silver Key';
    s 'Fear and Loathing';
    enemy 'Quicksilver';
  };
  room 'Buried Alive' {
    e 'Shelter From the Quake';
    enemy 'Fire Elemental';
    chest {
      'White Rose:Bec de Corbin.D/Grimoire Grip',
      'Grimoire Radius', 'Grimoire Meteore'
    };
  };
  room 'Movement of Fear' {
    w 'Shelter From the Quake';
    n 'Facing Your Illusions';
    enemy 'Air Elemental';
  };
  room 'Facing Your Illusions' {
    s 'Movement of Fear';
    e 'The Darkness Drinks';
    trap 'Diabolos';
    enemy 'Quicksilver';
  };
  room 'The Darkness Drinks' {
    w 'Facing Your Illusions';
    s 'Where Flood Waters Ran';
    enemy 'Earth Elemental';
  };
  room 'Fear and Loathing' {
    n 'Shelter From the Quake';
    s 'Blood and The Beast';
    enemy 'Ifrit' {
      miniboss = true;
      'Grimoire Flamme'
    };
    enemy 'Marid' {
      miniboss = true;
      'Grimoire Avalanche'
    };
  };
  room 'Blood and The Beast' {
    n 'Fear and Loathing';
    w 'Where Body and Soul Part';
    trap 'Poison Panel';
    enemy 'Water Elemental';
  };
  room 'Where Body and Soul Part' {
    e 'Blood and The Beast';
    enemy 'Quicksilver';
    chest {
      warded = true;
      'Bellini:Double Blade.S/Runkasyle', 'Vera Bulb x5', 'Elixir of Mages'
    };
  };
}

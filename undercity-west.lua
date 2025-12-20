region 'Undercity West' {
  'A large area with connections to seven other regions; however, much of it is locked behind NG+ keys, and on your first visit you are basically limited to fighting a giant crab and then exiting to Snowfly Forest.';

  room 'The Bread Peddler\'s Way' {
    s 'Villeport Way'; dx=0.5; dy=-7.5; -- to Town Centre West
    e 'Way of the Mother Lode';
  };
  room 'Way of the Mother Lode' {
    w 'The Bread Peddler\'s Way';
    e 'Sewer of Ravenous Rats';
    s 'Underdark Fishmarket';
    enemy 'Zombie Knight';
    enemy 'Ghast';
  };
  room 'Sewer of Ravenous Rats' {
    'Dead end until you have the Silver Key.';
    w 'Way of the Mother Lode';
    n 'Beggars of the Mouthharp' 'Silver Key';
    enemy 'Skeleton';
    enemy 'Zombie Mage';
  };
  room 'Underdark Fishmarket' {
    'Boss fight against Giant Crab.';
    n 'Way of the Mother Lode';
    s 'The Sunless Way';
    enemy 'Giant Crab' {
      boss = true;
      'Cure Bulb x3', 'Elixir of Queens', 'Grimoire Sylphe'
    };
  };
  room 'The Sunless Way' {
    n 'Underdark Fishmarket';
    s 'Dark Abhors Light' 'Iron Key'; -- to Limestone Quarry
    w 'Remembering Days of Yore';
    e 'Hall of Poverty';
  };
  -- West branch towards Snowfly Forest
  room 'Remembering Days of Yore' {
    e 'The Sunless Way';
    w 'Larder for a Lean Winter' 'Iron Key';
    s 'Where the Hunter Climbed';
    enemy 'Ghast';
    enemy 'Zombie Knight';
    enemy 'Zombie Mage';
  };
  room 'Larder for a Lean Winter' {
    e 'Remembering Days of Yore';
    enemy 'Dark Skeleton';
    enemy 'Lich';
    chest {
      'Balin\'s Revenge:Tabar.H/Heavy Grip', 'Vambrace.H',
      'Elixir of Sages', 'Alchemist\'s Reagent x5', 'Clematis Sigil'
    };
  };
  room 'Where the Hunter Climbed' {
    n 'Remembering Days of Yore';
    s 'The Faerie Circle';
  };
  -- East branch towards Abandoned Mines and Godhands
  room 'Hall of Poverty' {
    w 'The Sunless Way';
    -- e 'The Crumbling Market (South)'; -- latch
    s 'The Washing-Woman\'s Way';
    enemy 'Zombie Knight';
    enemy 'Ghast';
  };
  room 'The Washing-Woman\'s Way' {
    n 'Hall of Poverty';
    e 'Nameless Dark Oblivion' 'Silver Key';
    trap 'Heal Panel';
    trap 'Cure Panel';
    enemy 'Ghast';
    enemy 'Zombie Knight';
    enemy 'Zombie Mage';
  };
  -- Area reachable via City Walls East
  room 'Nameless Dark Oblivion' {
    w 'The Washing-Woman\'s Way' 'Silver Key';
    s 'Sinner\'s Corner';
    enemy 'Dark Skeleton';
    enemy 'Dark Eye';
  };
  room 'Sinner\'s Corner' {
    n 'Nameless Dark Oblivion';
    w 'The Children\'s Hideout';
    e 'Corner of Prayers';
    s 'Fear of the Fall';
    enemy 'Skeleton';
    enemy 'Dark Skeleton';
    enemy 'Dark Eye';
  };
  room 'Fear of the Fall' {
    n 'Sinner\'s Corner';
    s 'The Cornered Savage'; -- to City Walls East
    enemy 'Dark Elemental' {
      boss = true;
      'Cattleya Sigil', 'Grimoire Meteore'
    }
  };
  room 'The Children\'s Hideout' {
    e 'Sinner\'s Corner';
    enemy 'Gargoyle';
    enemy 'Dark Eye';
    chest {
      'Sweet Death:Shamshir.S/Knuckle Guard', 'Spiked Shield/White Queen',
      'Footman\'s Mace 1H.H', 'Steel Bolt', 'Sallet.H', 'Undine Bracelet',
      'Speedster', 'Grimoire Dissiper'
    };
  };
  room 'Corner of Prayers' {
    w 'Sinner\'s Corner';
    n 'Hope Obstructed';
    e 'Salvation for the Mother' 'Gold Key';
    enemy 'Dark Skeleton';
    enemy 'Dark Eye';
  };
  room 'Hope Obstructed' {
    s 'Corner of Prayers';
    n 'Work, Then Die'; -- to Abandoned Mines B2
    enemy 'Gargoyle';
  };
  -- North area accessible only with Silver Key and Rood Inverse
  -- TODO
  room 'Beggars of the Mouthharp' {
    s 'Sewer of Ravenous Rats' 'Silver Key';
    n 'Corner of the Wretched';
    enemy 'Lich';
    enemy 'Dullahan';
  };
  room 'Corner of the Wretched' {
    s 'Beggars of the Mouthharp';
    w 'Crossroads of Rest' 'Rood Inverse';
    enemy 'Dark Skeleton';
    enemy 'Lich';
  };
  room 'Crossroads of Rest' {
    e 'Corner of the Wretched' 'Rood Inverse';
    n 'Path to the Greengrocer';
    s 'Path of the Children';
    trap 'Gust';
    enemy 'Lich Lord';
  };
  room 'Path to the Greengrocer' {
    s 'Crossroads of Rest';
    e 'Glacialdra Kirk Ruins' 'Rood Inverse';
    enemy 'Dullahan';
    enemy 'Lich';
  };
  room 'Path of the Children' {
    n 'Crossroads of Rest';
    s 'Shelter From the Quake';
  };
  -- Southeast area accessible only with Gold Key
  room 'Salvation for the Mother' {
    w 'Corner of Prayers' 'Gold Key';
    n 'The Body Fragile Yields' 'Gold Key';
    e 'Bite the Master\'s Wounds';
    trap 'Diabolos';
    trap 'Poison Panel';
    enemy 'Lich';
    enemy 'Lich Lord';
  };
  room 'The Body Fragile Yields' {
    n 'Tears from Empty Sockets';
    s 'Salvation for the Mother' 'Gold Key';
    enemy 'Dullahan';
    enemy 'Lich Lord';
  };
  room 'Bite the Master\'s Wounds' {
    w 'Salvation for the Mother';
    n 'Workshop \'Godhands\'';
    enemy 'Death';
  };
  room 'Workshop \'Godhands\'' {
    s 'Bite the Master\'s Wounds';
    save_point = true;
    container = true;
    workshop = { 'L', 'B', 'I', 'H', 'S', 'D' };
  };
  -- Area reachable by going through Mines B2
  room 'The Crumbling Market (South)' {
    w 'Hall of Poverty'; -- latch to
    e 'Tears from Empty Sockets';
    nw 'Subtellurian Horrors'; -- to Abandoned Mines B2
    save_point = true;
    enemy 'Dullahan';
  };
  room 'The Crumbling Market (North)' {
    n 'Where Flood Waters Ran';
    s 'The Crumbling Market (South)' (false);
    trap 'Eruption';
    trap 'Freeze';
    trap 'Gust';
    trap 'Terra Thrust';
    trap 'Holy Light';
    chest {
      'Agales\'s Chain', 'Elixir of Queens', 'Valens', 'Gold Key'
    };
  };
  room 'Where Flood Waters Ran' {
    s 'The Crumbling Market (North)';
    n 'The Darkness Drinks'; -- to Escapeway
  };
  room 'Tears from Empty Sockets' {
    s 'The Body Fragile Yields';
    w 'The Crumbling Market (South)';
    e 'Rue Lejour'; -- to Town Centre East
    enemy 'Dark Skeleton';
  };
}

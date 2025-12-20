region 'Limestone Quarry' {
  room 'Dark Abhors Light' {
    n 'The Sunless Way'; dx=4.5; dy=-8; -- to Undercity West
    s 'Dream of the Holy Land';
  };
  room 'Dream of the Holy Land' {
    n 'Dark Abhors Light';
    s 'The Ore Road' 'Aster Sigil';
    enemy 'Water Elemental' {
      boss = true;
      'Grimoire Avalanche', 'Elixir of Sages', 'Acolyte\'s Nostrum'
    };
  };
  room 'The Ore Road' {
    n 'Dream of the Holy Land';
    e 'The Air Stirs';
    w 'Atone for Eternity';
    save_point = true;
  };
  room 'The Air Stirs' {
    w 'The Ore Road';
    e 'Bonds of Friendship';
    n 'Bacchus is Cheap';
    enemy 'Gremlin';
  };
  room 'Bonds of Friendship' {
    w 'The Air Stirs';
    enemy 'Air Elemental';
    chest {
      'Matador:Schiavona.H/Counter Guard', 'Cranequin.I',
      'Side Ring', 'Brigandine.H', 'Rondanche.H', 'Lionhead',
      'Snowfly Draught x5', 'Grimoire Benir'
    };
  };
  room 'Atone for Eternity' {
    e 'The Ore Road';
    n 'Stair to Sanctuary';
    trap 'Death Vapor';
    enemy 'Gremlin';
  };
  room 'Stair to Sanctuary' {
    s 'Atone for Eternity';
    n 'The Fallen Hall';
    enemy 'Wraith';
  };
  room 'The Fallen Hall' {
    'Enemy spawns depend on which door you enter via, either Ogres or Dullahans.';
    s 'Stair to Sanctuary';
    n 'The Rotten Core';
    enemy 'Dullahan';
    enemy 'Ogre';
  };
  room 'The Rotten Core' {
    s 'The Fallen Hall';
    e 'The Dreamer\'s Climb';
    enemy 'Gremlin';
  };
  room 'The Dreamer\'s Climb' {
    w 'The Rotten Core';
    e 'The Ore-Bearers';
    n 'Sinner\'s Sustenence' 'Eulelia Sigil';
    trap 'Heal Panel';
  };
  room 'The Ore-Bearers' {
    w 'The Dreamer\'s Climb';
    s 'Screams of the Wounded';
    trap 'Poison Panel';
    enemy 'Gremlin';
  };
  room 'Screams of the Wounded' {
    'Enemy spawns depend on which door you enter via, either Ogres or Dullahans.';
    n 'The Ore-Bearers';
    s 'Bacchus is Cheap';
    enemy 'Dullahan';
    enemy 'Ogre';
  };
  room 'Bacchus is Cheap' {
    n 'Screams of the Wounded';
    s 'The Air Stirs';
    enemy 'Wraith';
  };
  room 'Sinner\'s Sustenence' {
    s 'The Dreamer\'s Climb';
    n 'The Timely Dew of Sleep';
    enemy 'Wraith';
  };
  room 'The Timely Dew of Sleep' {
    s 'Sinner\'s Sustenence';
    w 'The Auction Block';
    e 'Companions in Arms' 'Gold Key';
    enemy 'Gramlin';
  };
  -- Gold key side room
  room 'Companions in Arms' {
    w 'The Timely Dew of Sleep';
    enemy 'Fire Elemental';
    chest {
      warded = true;
      'Death Sentence:Executioner.D/Side Ring/Balvus/Beowulf',
      'Casserole Shield/Orlandu/Ogmius', 'Spiral Pole',
      'Close Helm.D', 'Plate Mail.D', 'Edgar\'s Earrings',
      'Grimoire Fleau'
    };
  };
  room 'The Auction Block' {
    e 'The Timely Dew of Sleep';
    w 'The Laborer\'s Bonfire';
    n 'Ascension' 'Silver Key';
    save_point = true;
  };
  -- Silver key side passage to Temple of Kiltia [
  room 'Ascension' {
    s 'The Auction Block';
    n 'Where the Serpent Hunts';
    enemy 'Wraith';
  };
  room 'Where the Serpent Hunts' {
    s 'Ascension';
    e 'Drowned in Fleeting Joy';
    w 'Ants Prepare for Winter';
    enemy 'Gremlin';
  };
  room 'Drowned in Fleeting Joy' {
    w 'Where the Serpent Hunts';
    enemy 'Dark Elemental';
    chest {
      'Falarica Bolt', 'Plate Glove.H', 'Elixir of Mages',
      'Mana Potion x5'
    };
  };
  room 'Ants Prepare for Winter' {
    e 'Where the Serpent Hunts';
    w 'Those who Drink the Dark'; -- to Temple of Kiltia
  };
  -- ] and back to the main branch.
  room 'The Laborer\'s Bonfire' {
    e 'The Auction Block';
    w 'Stone and Sulfurous Fire';
    s 'Torture Without End' 'Melissa Sigil';
    trap 'Paralysis Panel';
  };
  room 'Stone and Sulfurous Fire' {
    e 'The Laborer\'s Bonfire';
    enemy 'Earth Elemental';
    chest {
      'White Lady:Morning Star.H/Runkasyle', 'Kite Shield.H/Silent Queen',
      'Balbriggan.B', 'Power Palm', 'Talos Feldspar',
      'Acolyte\'s Nostrum x3', 'Grimoire Egout'
    };
  };
  room 'Torture Without End' {
    n 'The Laborer\'s Bonfire';
    s 'Way Down';
    enemy 'Ogre Lord' {
      boss = true;
      'Agales\'s Chain', 'Schiavona.I/Power Palm/Braveheart/Morlock Jet',
      'Elixir of Queens', 'Mana Tonic x3', 'Cure Potion'
    };
  };
  room 'Way Down' {
    n 'Torture Without End';
    ne 'Excavated Hollow';
    s 'Parting Regrets';
    save_point = true;
  };
  room 'Excavated Hollow' {
    sw 'Way Down';
    enemy 'Water Elemental';
    chest {
      'Angel Face:Balbriggan.H/Heavy Grip', 'Casserole Shield.H',
      'Elephant', 'Missaglia.I', 'Beaded Anklet', 'Elixir of Queens',
      'Grimoire Flamme'
    };
  };
  room 'Parting Regrets' {
    n 'Way Down';
    s 'Corridor of Tales';
    enemy 'Wraith';
  };
  room 'Corridor of Tales' {
    n 'Parting Regrets';
    w 'Dust Shall Eat the Days';
    enemy 'Gremlin';
    enemy 'Ogre';
  };
  room 'Dust Shall Eat the Days' {
    e 'Corridor of Tales';
    n 'Hall of the Wage-Paying';
  };
  room 'Hall of the Wage-Paying' {
    s 'Dust Shall Eat the Days';
    n 'Tunnel of the Heartless';
    enemy 'Snow Dragon' {
      boss = true;
      'Grimoire Barrer', 'Panacea', 'Elixir of Queens'
    };
  };
  room 'Tunnel of the Heartless' {
    s 'Hall of the Wage-Paying';
    n 'The Dark Coast'; -- to Temple of Kiltia
    puzzle = true;
  };
}

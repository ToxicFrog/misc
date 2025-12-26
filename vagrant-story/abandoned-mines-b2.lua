region 'Abandoned Mines B2' {
  'This is a huge area which is almost completely optional; by grabbing the Mandrake Sigil from Iron Maiden B1, then cutting through City Walls East and Undercity West to Work, Then Die, you can skip right to the end.';
  -- area reachable from Undercity West
  room 'Subtellurian Horrors' {
    sw 'The Crumbling Market (South)'; dx=12; dy=9; -- to Undercity West
    s 'Dining in Darkness';
  };
  room 'Dining in Darkness' {
    s 'Bandit\'s Hollow';
    n 'Subtellurian Horrors';
    enemy 'Sky Dragon' {
      boss = true;
      'Tearose Sigil', 'Grimoire Demance', 'Elixir of Queens'
    };
  };
  room 'Bandit\'s Hollow' {
    -- w -- one-way from The Lunatic Veins
    -- s -- one-way from Work, Then Die
    e 'Delusions of Happiness' 'Iron Key';
    n 'Dining in Darkness';
    enemy 'Blood Lizard';
    enemy 'Imp';
  };
  -- Side room
  room 'Delusions of Happiness' {
    w 'Bandit\'s Hollow';
    enemy 'Blood Lizard';
    chest {
      'Pirate\'s Mate:Sabre Halberd.H/Sarissa Grip',
      'Heater Shield/Orion', 'Kris.D', 'Swan Song',
      'Vera Potion x3', 'Grimoire Salamandre'
    };
  };
  -- South entrance from Undercity Weast
  room 'Work, Then Die' {
    n 'Bandit\'s Hollow'; -- ONE WAY. DOES NOT UNLATCH.
    s 'Hope Obstructed'; -- to Undercity West
  };
  -- West entrance from Town Centre South via time trial.
  room 'The Lunatic Veins' {
    e 'Bandit\'s Hollow'; -- ONE WAY. DOES NOT UNLATCH.
    s 'Tomb of the Reborn';
    enemy 'Slime';
    enemy 'Poison Slime';
  };
  room 'Tomb of the Reborn' {
    n 'The Lunatic Veins';
    s 'Fool\'s Gold, Fool\'s Loss';
    enemy 'Earth Elemental' {
      boss = true;
      'Grimoire Gaea'
    };
  };
  room 'Fool\'s Gold, Fool\'s Loss' {
    n 'Tomb of the Reborn';
    s 'Kilroy Was Here';
    w 'Crossing of Blood';
    trap 'Paralysis Panel';
  };
  room 'Kilroy Was Here' {
    n 'Fool\'s Gold, Fool\'s Loss'; dy=-0.5;
    s 'A Wager of Noble Gold';
    enemy 'Orc Leader';
  };
  room 'A Wager of Noble Gold' {
    n 'Kilroy Was Here'; dy=0.5;
    w 'Lambs to the Slaughter';
    enemy 'Orc';
    enemy 'Orc Leader';
  };
  room 'Lambs to the Slaughter' {
    e 'A Wager of Noble Gold';
    w 'The Ore of Legend';
    trap 'Heal Panel';
    enemy 'Slime';
    enemy 'Poison Slime';
  };
  room 'The Ore of Legend' {
    e 'Lambs to the Slaughter';
    n 'Cry of the Beast';
    w 'Suicidal Desires';
    enemy 'Orc';
    enemy 'Orc Leader';
  };
  room 'Suicidal Desires' {
    e 'The Ore of Legend';
    trap 'Death Vapor';
    trap 'Paralysis Panel';
    trap 'Holy Light';
    trap 'Terra Thrust';
    trap 'Gust';
    trap 'Freeze';
    trap 'Eruption';
    trap 'Trap Clear';
    enemy 'Mimic';
    enemy 'Imp';
    chest {
      'Dog\'s Nose:Footman\'s Mace 2H/Sarissa Grip', 'Target Bow.I', 'Barbut.S', 'Gnome Bracelet', 'Elixir of Queens', 'Vera Bulb x3'
    };
  };
  room 'Cry of the Beast' {
    s 'The Ore of Legend'; dy=-0.5;
    n 'The Fallen Bricklayer';
    enemy 'Orc';
  };
  room 'The Fallen Bricklayer' {
    s 'Cry of the Beast'; dy=0.5;
    n 'Hall of Contemplation';
    e 'Crossing of Blood';
  };
  room 'Hall of Contemplation' {
    s 'The Fallen Bricklayer';
    e 'The Abandoned Catspaw';
    n 'Hall of the Empty Sconce';
    trap 'Eruption';
    enemy 'Orc';
    enemy 'Orc Leader';
  };
  room 'Hall of the Empty Sconce' {
    s 'Hall of Contemplation';
    e 'Acolyte\'s Burial Vault';
    enemy 'Orc';
    enemy 'Orc Leader';
  };
  room 'Acolyte\'s Burial Vault' {
    w 'Hall of the Empty Sconce';
    enemy 'Mimic';
    enemy 'Imp';
    chest {
      'Affinity:Corcesca.H/Spiculum Pole', 'Circle Shield.H/Brainshield', 'Framea Pole', 'Gauntlet.H', 'Hellraiser', 'Grimoire Vie'
    };
  };
  room 'The Abandoned Catspaw' {
    w 'Hall of Contemplation';
    s 'Crossing of Blood';
    enemy 'Slime';
    enemy 'Poison Slime';
  };
  room 'Crossing of Blood' {
    n 'The Abandoned Catspaw';
    s 'Senses Lost';
    w 'The Fallen Bricklayer';
    e 'Fool\'s Gold, Fool\'s Loss';
    trap 'Holy Light';
    trap 'Diabolos';
    enemy 'Orc';
    enemy 'Orc Leader';
  };
  room 'Senses Lost' {
    n 'Crossing of Blood';
    w 'Desire\'s Passage';
    trap 'Eruption';
    trap 'Poison Panel';
    enemy 'Orc';
    enemy 'Orc Leader';
  };
  room 'Desire\'s Passage' {
    e 'Senses Lost';
    w 'Way of Lost Children';
    trap 'Cure Panel';
    enemy 'Slime';
  };
  room 'Way of Lost Children' {
    'Entering this room from the north starts a time trial. It ends when you reach Bandits\' Hollow, which is (by the shortest path) seven rooms away; if you time out, you are teleported back to Treaty Room. There are three chests off the shortest path one may wish to detour to.';
    e 'Desire\'s Passage';
    n 'Treaty Room';
    w 'Hidden Resources';
    enemy 'Orc';
    enemy 'Orc Leader';
  };
  room 'Hidden Resources' {
    e 'Way of Lost Children';
    enemy 'Mimic';
    enemy 'Imp';
    chest {
      locked = true;
      'Eviscerator:Kudi.S/Knuckle Guard', 'Tower Shield.I/Gnome Emerald', 'Breastplate.I', 'Fusskampf.H',
      'Trinity', 'Saint\'s Nostrum x3', 'Grimoire Mollesse'
    };
  };
  room 'Treaty Room' {
    s 'Way of Lost Children';
    n 'The Miner\'s End';
    save_point = true;
    enemy 'Slime';
    enemy 'Poison Slime';
  };
  room 'The Miner\'s End' {
    s 'Treaty Room';
    n 'Gambler\'s Passage';
    enemy 'Air Elemental' {
      boss = true;
      'Grimoire Foudre', 'Mana Bulb'
    };
  };
  room 'Gambler\'s Passage' {
    s 'The Miner\'s End';
    n 'Revelation Shaft';
    enemy 'Orc';
  };
  room 'Revelation Shaft' {
    s 'Gambler\'s Passage';
    w 'Corridor of Shade';
  };
  room 'Corridor of Shade' {
    e 'Revelation Shaft';
    s 'Rue Morgue';
  };
}


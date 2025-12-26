region 'Iron Maiden B2' {
  -- Typo in original
  room 'The Eunics\' Lot' {
    n 'Knotting'; dx=1; -- to Iron Maiden B1
    s 'Ordeal By Fire';
    enemy 'Shrieker';
    enemy 'Dark Crusader';
  };
  room 'Ordeal By Fire' {
    n 'The Eunics\' Lot';
    s 'The Oven at Neisse';
    enemy 'Dark Dragon' {
      miniboss = true;
      'Verbena Sigil', 'Elixir of Kings'
    }
  };
  room 'The Oven at Neisse' {
    n 'Ordeal By Fire';
    s 'Pressing';
    enemy 'Dark Crusader';
  };
  room 'Pressing' {
    n 'The Oven at Neisse';
    s 'The Mind Burns';
    enemy 'Ravana' {
      miniboss = true;
      'Schirra Sigil'
    }
  };
  room 'The Mind Burns' {
    n 'Pressing';
    s 'The Rack';
    trap 'Freeze';
    trap 'Gust';
    enemy 'Shrieker';
    enemy 'Dark Crusader';
  };
  room 'The Rack' {
    n 'The Mind Burns';
    s 'The Saw';
    enemy 'Ogre';
    enemy 'Dark Crusader';
  };
  room 'The Saw' {
    n 'The Rack';
    s 'The Cold\'s Bridle';
    enemy 'Dragon Zombie' {
      miniboss = true;
      'Marigold Sigil'
    }
  };
  -- Typo in original
  room 'The Cold\'s Bridle' {
    n 'The Saw';
    s 'The Shin-Vice';
    trap 'Curse Panel';
    trap 'Death Vapor';
    trap 'Poison Panel';
    enemy 'Ogre';
    enemy 'Dark Crusader';
  };
  room 'The Shin-Vice' {
    n 'The Cold\'s Bridle';
    s 'The Spider';
    enemy 'Ogre Zombie' {
      miniboss = true;
      'Azalea Sigil'
    };
    enemy 'Death' {
      miniboss = true;
    };
  };
  room 'The Spider' {
    n 'The Shin-Vice';
    e 'Lead Sprinkler';
    w 'Squassation';
    s 'The Strappado';
    enemy 'Shrieker';
    enemy 'Dark Crusader';
  };
  room 'Lead Sprinkler' {
    w 'The Spider';
    trap 'Paralysis Panel';
    enemy 'Lich';
    enemy 'Shrieker';
    chest { 'Hoplite Helm.H', 'Mana Potion x3' };
  };
  room 'Squassation' {
    e 'The Spider';
    trap 'Poison Panel';
    trap 'Terra Thrust';
    enemy 'Lich';
    enemy 'Shrieker';
    chest { 'Holite Shield.H', 'Cure Potion x3' };
  };
  room 'The Strappado' {
    w 'Thumbscrews';
    n 'The Spider';
    e 'Tablillas';
    s 'Tongue Slicer';
    enemy 'Lich Lord';
  };
  room 'Thumbscrews' {
    e 'The Strappado';
    w 'Pendulum';
    s 'Pendulum';
    n 'Brank';
    enemy 'Lich Lord';
  };
  room 'Pendulum' {
    e 'Thumbscrews';
    n 'Thumbscrews';
    w 'Brank';
    s 'Dragging';
    trap 'Curse Panel';
  };
  room 'Dragging' {
    n 'Pendulum';
    e 'Strangulation';
    w 'Ordeal by Water';
    s 'The Rack';
    trap 'Curse Panel';
  };
  room 'Strangulation' {
    w 'Dragging';
    n 'Tablillas';
    s 'Ordeal by Water';
    e 'Tongue Slicer';
    enemy 'Lich';
  };
  room 'Tablillas' {
    w 'The Strappado';
    e 'Tormentum Insomniae';
    n 'Ordeal by Water';
    s 'Strangulation';
    enemy 'Lich';
    enemy 'Dark Crusader';
  };
  room 'Tongue Slicer' {
    n 'The Strappado';
    w 'Strangulation';
    e 'Ordeal by Water';
    s 'Brank';
    enemy 'Shrieker';
  };
  room 'Ordeal by Water' {
    w 'Tongue Slicer';
    n 'Strangulation';
    e 'Dragging';
    s 'Tablillas';
  };
  room 'Brank' {
    n 'Tongue Slicer';
    w 'Tormentum Insomniae';
    e 'Pendulum';
    s 'Thumbscrews';
    enemy 'Dark Crusader';
  };
  room 'Tormentum Insomniae' {
    w 'Tablillas';
    e 'Brank';
    s 'The Rack';
    n 'The Iron Maiden'; -- to Iron Maiden B3
    enemy 'Ogre';
    enemy 'Ogre Lord';
    enemy 'Last Crusader';
  };
}

region 'Iron Maiden B3' {
  room 'The Iron Maiden' {
    s 'Tormentum Insomniae'; dx=1; dy=1; -- to Iron Maiden B2
    enemy 'Asura' {
      boss = true;
      'Tigertail Sigil', 'Cure Potion'
    };
  };
  room 'Judgement' {
    s 'The Iron Maiden';
    w 'Saint Elmo\'s Belt';
    e 'Dunking the Witch';
    n 'The Soldier\'s Bedding'; -- to The Keep
  };
  room 'Saint Elmo\'s Belt' {
    e 'Judgement';
    enemy 'Lich Lord';
    chest { 'Hoplite Leggings.H', 'Hoplite Glove.H', 'Elixir of Kings', 'Elixir of Queens' };
  };
  room 'Dunking the Witch' {
    w 'Judgement';
    enemy 'Lich Lord';
    chest { 'Hoplite Armor.H', 'Hoplite Glove.H', 'Elixir of Kings', 'Elixir of Queens' };
  };
}

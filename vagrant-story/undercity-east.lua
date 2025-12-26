region 'Undercity East' {
  'The majority of Undercity East, initially accessed via Town Centre East.';
  room 'Hall to a New World' {
    n 'Shasras Hill Park'; dx=5; dy=4; -- to Town Centre East
    s 'Place of Free Words';
    enemy 'Quicksilver';
  };
  room 'Place of Free Words' {
    n 'Hall to a New World';
    s 'Bazaar of the Bizarre';
    enemy 'Harpy' {
      miniboss = true;
      'Grimoire Intensite', 'Angelic Paean x5', 'Cure Tonic'
    };
  };
  room 'Bazaar of the Bizarre' {
    'Boss fight againt the Lich to FINALLY GET TELEPORT.';
    n 'Place of Free Words';
    s 'Noble Gold and Silk';
    enemy 'Lich' {
      boss = true;
      'Agales\'s Chain', 'Summoner Baton.I/Gendarme', 'Eulelia Sigil',
      'Mana Tonic', 'Elixir of Mages', 'Teleport'
    }
  };
  room 'Noble Gold and Silk' {
    n 'Bazaar of the Bizarre';
    w 'Weapons Not Allowed';
    e 'A Knight Sells his Sword' 'Iron Key';
    enemy 'Quicksilver';
  };
  room 'Weapons Not Allowed' {
    e 'Noble Gold and Silk';
    enemy 'Quicksilver';
    enemy 'Lich';
    chest {
      'Mojito:Falchion.B/Counter Guard', 'Stone Bullet', 'Titan\'s Ring',
      'Grimoire Nuageux', 'Iron Key'
    };
  };
  room 'A Knight Sells his Sword' {
    w 'Noble Gold and Silk';
    n 'Traces of Invasion Past'; -- to City Walls North
    s 'Gemsword Blackmarket';
    enemy 'Harpy';
    enemy 'Quicksilver';
  };
  room 'Gemsword Blackmarket' {
    n 'A Knight Sells his Sword';
    s 'The Pirate\'s Son';
    enemy 'Nightstalker' {
      boss = true;
      'Melissa Sigil', 'Grimoire Eclairer', 'Angelic Paean'
    }
  };
  room 'The Pirate\'s Son' {
    n 'Gemsword Blackmarket';
    w 'Sale of the Sword';
    enemy 'Harpy';
    enemy 'Quicksilver';
  };
  room 'Sale of the Sword' {
    e 'The Pirate\'s Son';
    enemy 'Quicksilver';
    enemy 'Lich';
    chest {
      'Ahlspies', 'Pushpaka', 'Grimoire Tardif', 'Stock Sigil'
    };
  };
}

region 'Undercity East (North)' {
  'This area is discontiguous with the rest of Undercity East and is reachable only via City Walls North once you have the iron key.';
  room 'The Greengrocer\'s Stair' {
    'Neesa & Tieger are placed here, even though the actual fight is in Black Waters, because the fight is triggered by entering this room.';
    s 'A Welcome Invasion';
    n 'Where Black Waters Ran';
    enemy 'Neesa' {
      miniboss = true;
      after = 'Catspaw Blackmarket';
    };
    enemy 'Tieger' {
      miniboss = true;
      after = 'Catspaw Blackmarket';
    };
  };
  room 'Where Black Waters Ran' {
    n 'Arms Against Invaders';
    s 'The Greengrocer\'s Stair';
    enemy 'Quicksilver';
    enemy 'Lich';
  };
  room 'Arms Against Invaders' {
    s 'Where Black Waters Ran';
    w 'Catspaw Blackmarket';
    enemy 'Harpy';
  };
  room 'Catspaw Blackmarket' {
    e 'Arms Against Invaders';
    trap 'Diabolos';
    trap 'Trap Clear';
    enemy 'Quicksilver';
    enemy 'Lich';
    chest {
      'Round Shield.H/Dark Queen', 'Grimoire Paralysie', 'Aster Sigil'
    }
  };
}


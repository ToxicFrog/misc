-- Contains all the different interconnected floors of the Cathedral.
-- There are a lot of not-really-connected rooms here.
-- Edges with a lock of (false) are not traversable and are used
-- only for positioning in the visual map.

region 'Great Cathedral L1' {
  room 'Into Holy Battle' {
    e 'Plateia Lumitar'; dy=4; -- to Town Centre East
    w 'Struggle for the Soul'; -- to B1
    n 'The Convent Room' 'Truth and Lies'; -- to L2
  };
  room 'The Poisoned Chapel' {
    e 'Into Holy Battle' (false);
    s 'Sin and Punishment';
    n 'A Light in the Dark' 'Laurel Sigil';
  };
  room 'Sin and Punishment' {
    -- You can use this door any time, but you can't actually
    -- reach the north half of Poisoned Chapel until you unlock
    -- the cloudstone at Flayed Confessional.
    n 'The Poisoned Chapel' 'Flayed Confessional';
    w 'An Offering of Souls';
    save_point = true;
    container = true;
    trap 'Curse Panel';
    trap 'Eruption';
  };
  room 'A Light in the Dark' {
    s 'The Poisoned Chapel';
    enemy 'Arch Dragon' {
      miniboss = true;
      'Acacia Sigil', 'Acolyte\'s Nostrum'
    };
  };
  room 'Monk\'s Leap' {
    e 'The Poisoned Chapel' (false);
    n 'The Acolyte\'s Weakness'; -- stairs to L2
    enemy 'Lich' {
      miniboss = true;
      'Laurel Sigil', 'Elixir of Queens', 'Grimoire Demolir', 'Ghost Hound';
    };
    enemy 'Zombie Knight';
  };
  room 'Hieratic Recollections' {
    s 'A Light in the Dark' (false);
    w 'The Flayed Confessional';
    e 'Cracked Pleasures';
  };
  room 'The Flayed Confessional' {
    'Fight against Djinn to unlock the cloudstone in Poisoned Chapel.';
    e 'Hieratic Recollections';
    enemy 'Djinn' {
      boss = true;
      'Elixir of Queens', 'Grimoire Foudre'
    };
    chest {
      'Fluted Armor.H', 'Fluted Glove.H', 'Vera Potion x3', 'Saint\'s Nostrum'
    };
  };
  room 'Cracked Pleasures' {
    w 'Hieratic Recollections';
    e 'The Victor\'s Laurels';
    nw 'Free from Base Desires'; -- cloudstone to L2
  };
  room 'Where Darkness Spreads' {
    'This looks like it should be an Evolve or Die puzzle, but it isn\'t.';
    s 'Hieratic Recollections' (false);
    n 'An Arrow into Darkness'; -- cloudstone to L2
    chest {
      'Oval Shield.H/Morlock Jet', 'Burgonet.H', 'Mana Bulb x5', 'Elixir of Queens'
    };
  };
}

region 'Great Cathedral B1' {
  room 'Struggle for the Soul' {
    e 'Into Holy Battle'; dx=4; dy=0.5; -- to L1
    sw 'Order and Chaos';
    nw 'Truth and Lies';
    trap 'Heal Panel';
  };
  room 'Order and Chaos' {
    'Defeat Marid to unlock the cloudstone in Victor\'s Laurels.';
    ne 'Struggle for the Soul';
    e 'An Offering of Souls';
    enemy 'Marid' {
      boss = true;
      'Elixir of Queens', 'Grimoire Avalanche'
    };
  };
  room 'An Offering of Souls' {
    w 'Order and Chaos';
    e 'Sin and Punishment'; -- to L1
  };
  room 'Truth and Lies' {
    se 'Struggle for the Soul';
    w 'Sanity and Madness';
    e 'The Victor\'s Laurels';
    enemy 'Ifrit' {
      boss = true;
      'Elixir of Queens', 'Grimoire Flamme'
    };
  };
  room 'Sanity and Madness' {
    e 'Truth and Lies';
    enemy 'Iron Crab' {
      boss = true;
      'Valens', 'Elixir of Kings'
    };
  };
  room 'The Victor\'s Laurels' {
    'The cloudstone here is unlocked by defeating Marid in Order and Chaos.';
    w 'Truth and Lies';
    e 'Cracked Pleasures' 'Order and Chaos'; -- to L1
  };
}

region 'Great Cathedral L2' {
  room 'Free from Base Desires' {
    se 'Cracked Pleasures'; dx=-2; dy=1; -- cloudstone to L1
    s 'Abasement from Above';
    nw 'The Wine-Lecher\'s Fall'; -- cloudstone to L3
  };
  room 'Abasement from Above' {
    n 'Free from Base Desires';
    s 'The Convent Room'; -- One-way due to tricky jumps
    w 'The Hall of Broken Vows';
    trap 'Poison Panel';
    trap 'Paralysis Panel';
    trap 'Curse Panel';
  };
  room 'The Convent Room' {
    s 'Into Holy Battle'; dx=-3; dy=1;
    -- Can go north into Abasement from Above, but there's a gap in
    -- the floor and the jump is too far.
  };
  room 'The Hall of Broken Vows' {
    e 'Abasement from Above';
    s 'The Melodics of Madness' 'Acacia Sigil';
    w 'He Screams for Mercy';
    n 'Light and Dark Wage War';
    enemy 'Flame Dragon' {
      miniboss = true;
      'Calla Sigil', 'Sorcerer\'s Reagent'
    };
  };
  room 'Light and Dark Wage War' {
    'Don\'t forget the lever in the northwest corner!';
    s 'The Hall of Broken Vows';
    n 'An Arrow into Darkness';

  };
  room 'An Arrow into Darkness' {
    s 'Light and Dark Wage War';
    s 'Where Darkness Spreads'; -- cloudstone to L1
    chest {
      'Fluted Leggings.H', 'Fluted Glove.H', 'Eye of Argon x5', 'Cure Potion'
    };
  };
  room 'He Screams for Mercy' {
    'The jumps are tricky, but the room is traversable in all directions without speedtricks or faerie wings.';
    e 'The Hall of Broken Vows';
    n 'Maelstrom of Malice';
    s 'The Acolyte\'s Weakness';
    trap 'Terra Thrust';
    trap 'Cure Panel';
  };
  room 'The Acolyte\'s Weakness' {
    n 'He Screams for Mercy';
    s 'Monk\'s Leap'; -- stairs to L1
  };
  room 'Maelstrom of Malice' {
    'Defeating the Lich Lord here unlocks the cloudstone in Heretics\'s Story.';
    s 'He Screams for Mercy';
    enemy 'Lich Lord' {
      miniboss = true;
      'Elixir of Queens', 'Elixir of Mages', 'Grimoire Radius'
    };
    enemy 'Skeleton';
  };
  room 'The Melodics of Madness' {
    n 'The Hall of Broken Vows';
    s 'What Ails You, Kills You' 'Palm Sigil';
  };
  room 'What Ails You, Kills You' {
    n 'The Melodics of Madness';
    n 'Despair of the Fallen'; -- cloudstone to L3
    enemy 'Nightmare' {
      boss = true;
      'Grimoire Meteore', 'Elixir of Dragoons'
    };
  };
}

region 'Great Cathedral L3' {
  room 'The Wine-Lecher\'s Fall' {
    'Entrance from L2 via Cloudstone.';
    s 'Free from Base Desires'; dx=-3;
    w 'The Heretics\' Story (Lower)';
  };
  -- This room is divided into upper and lower halves. The lower half
  -- runs east-west and the upper half north-south. You can drop down
  -- from the upper area to the lower, but there's no way to climb
  -- from the lower to the upper.
  room 'The Heretics\' Story (Lower)' {
    e 'The Wine-Lecher\'s Fall';
    w 'Hopes of the Idealist' 'Calla Sigil';
  };
  room 'The Heretics\' Story (Upper)' {
    -- Can drop down to the lower level, but not climb back up
    se 'The Heretics\' Story (Lower)'; dx=0.8; dy=-0.5;
    s 'Despair of the Fallen';
    n 'Where the Soul Rots' 'Light and Dark Wage War'; -- Unlocked by lever in L2
  };
  room 'Despair of the Fallen' {
    -- You can traverse this door without visiting Malice, but until
    -- you do, the cloudstone that lets you cross Story is locked.
    n 'The Heretics\' Story (Upper)' 'Maelstrom of Malice';
    s 'What Ails You, Kills You';
  };
  room 'Hopes of the Idealist' {
    e 'The Heretics\' Story (Lower)';
    enemy 'Dao' {
      boss = true;
      'Palm Sigil', 'Elixir of Queens', 'Grimoire Gaea'
    };
  };
  room 'Where the Soul Rots' {
    s 'The Heretics\' Story (Upper)';
    e 'The Atrium';
  };
}

region 'Great Cathedral L4' {
  room 'The Atrium' {
    w 'Where the Soul Rots';
    e 'Dome';
    save_point = true;
  }
}

region 'Great Cathedral Dome' {
  room 'Dome' {
    w 'The Atrium';
    e 'Paling';
    enemy 'Guildenstern' {
      boss = true;
    };
  };
  room 'Paling' {
    w 'Dome';
    enemy 'Guildenstern Apotheos' {
      boss = true;
    };
  }
}

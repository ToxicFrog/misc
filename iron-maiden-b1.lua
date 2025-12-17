region 'Iron Maiden B1' {
  'Most of this area is inaccessible until you have the Tearose Sigil.';
  room 'The Cage' {
    n 'The Soldier\'s Bedding'; dx=7; dy=-1; -- to The Keep
    s 'The Cauldron';
  };
  room 'The Cauldron' {
    n 'The Cage';
    s 'Wooden Horse' 'Tearose Sigil';
    enemy 'Gargoyle' {
      miniboss = true;
      'Spirit Orison x3', 'Vera Bulb x3'
    };
    enemy 'Gargoyle' {
      miniboss = true;
      'Spirit Orison x3', 'Vera Bulb x3'
    };
    enemy 'Wraith' {
      miniboss = true;
      'Mandrake Sigil', 'Grimoire Exsorcer'
    };
  };
  room 'Wooden Horse' {
    n 'The Cauldron';
    s 'Starvation';
  };
  room 'Starvation' {
    n 'Wooden Horse';
    s 'The Breast Ripper';
    enemy 'Wraith' {
      miniboss = true;
      'Kalmia Sigil', 'Grimoire Venin'
    };
    enemy 'Mummy' {
      miniboss = true;
      'Shamshir.H/Knuckle Guard', 'Vera Bulb x3'
    };
  };
  room 'The Breast Ripper' {
    n 'Starvation';
    e 'The Wheel';
    w 'The Branks';
    s 'The Pear';
  };
  room 'The Wheel' {
    w 'The Breast Ripper';
    enemy 'Dark Skeleton';
    enemy 'Shadow';
    chest {
      warded = true;
      'Bull Shot:Griever.H/Bhuj Type', 'Baselard.H',
      'Djinn Amber', 'Valens'
    };
  };
  room 'The Branks' {
    e 'The Breast Ripper';
    enemy 'Dark Skeleton';
    enemy 'Shadow';
    chest {
      locked = true;
      'Balalaika:Double Blade.H/Bhuj Type',
      'Bec de Corbin.H', 'Dao Moonstone', 'Volare'
    };
  };
  room 'The Pear' {
    -- TODO: the jump to get back out of here is an absolute bastard
    -- without faerie wing. We may want to require that before this
    -- is in logic, either in the pool or via access to snowfly forest.
    -- alternately, if we have a Super Metroid style teleport-to-save
    -- command, that guarantees we can't get stuck.
    n 'The Breast Ripper';
    e 'The Judas Cradle';
    w 'The Whirlygig';
  };
  room 'The Judas Cradle' {
    w 'The Pear';
    enemy 'Dark Skeleton';
    chest {
      'Sonora:Bastard Sword.H/Power Palm', 'Bullova.H',
      'Ifrit Carnelian', 'Prudens'
    };
  };
  room 'The Whirlygig' {
    e 'The Pear'; dx=-1;
    n 'Spanish Tickler';
    enemy 'Dark Skeleton';
  };
  room 'Spanish Tickler' {
    s 'The Whirlygig';
    n 'Heretic\'s Fork';
    enemy 'Wyvern Knight' {
      miniboss = true;
      'Elixir of Dragoons', 'Elixir of Queens', 'Chest Key'
    };
  };
  room 'Heretic\'s Fork' {
    s 'Spanish Tickler';
    e 'The Chair of Spikes';
    trap 'Freeze';
    trap 'Gust';
    enemy 'Dark Skeleton';
  };
  room 'The Chair of Spikes' {
    w 'Heretic\'s Fork';
    e 'Blooding';
    enemy 'Dark Skeleton';
    enemy 'Wraith';
  };
  room 'Blooding' {
    w 'The Chair of Spikes'; dx=2;
    s 'Bootikens';
    trap 'Death Vapor';
    trap 'Eruption';
    enemy 'Dark Skeleton';
  };
  room 'Bootikens' {
    n 'Blooding';
    s 'Burial';
  };
  room 'Burial' {
    n 'Bootikens';
    s 'Burning';
    enemy 'Iron Golem' {
      boss = true;
      'Columbine Sigil', 'Elixir of Dragoons'
    }
  };
  room 'Burning' {
    n 'Burial'; dy=-1;
    w 'Cleansing the Soul';
    trap 'Terra Thrust';
    trap 'Holy Light';
  };
  room 'Cleansing the Soul' {
    e 'Burning';
    w 'The Ducking Stool';
    n 'The Garotte';
    enemy 'Dark Skeleton';
    enemy 'Wraith';
  };
  room 'The Ducking Stool' {
    e 'Cleansing the Soul';
    enemy 'Dark Skeleton';
    enemy 'Shadow';
    chest {
      'Red Viking:Khora.H/Power Palm', 'Pole Axe.H',
      'Marid Aquamarine', 'Virtus'
    };
  };
  room 'The Garotte' {
    s 'Cleansing the Soul';
    w 'Hanging';
  };
  room 'Hanging' {
    e 'The Garotte'; dx=-1;
    s 'Impalement' 'Steel Key';
    enemy 'Dark Skeleton';
    enemy 'Wraith';
  };
  room 'Impalement' {
    n 'Hanging';
    s 'Knotting' 'Platinum Key';
  };
  room 'Knotting' {
    n 'Impalement';
    s 'The Eunics\' Lot'; -- to Iron Maiden B2
    enemy 'Wyvern Queen' {
      miniboss = true;
      'Anemone Sigil', 'Elixir of Sages'
    };
  };
}

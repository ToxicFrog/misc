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
  };
  room 'The Breast Ripper' {
    n 'Starvation';
    e 'The Wheel';
    w 'The Branks';
    s 'The Pear';
  };
  room 'The Wheel' {
    w 'The Breast Ripper';
  };
  room 'The Branks' {
    e 'The Breast Ripper';
  };
  room 'The Pear' {
    n 'The Breast Ripper';
    e 'The Judas Cradle';
    w 'The Whirlygig';
  };
  room 'The Judas Cradle' {
    w 'The Pear';
  };
  room 'The Whirlygig' {
    e 'The Pear'; dx=-1;
    n 'Spanish Tickler';
  };
  room 'Spanish Tickler' {
    s 'The Whirlygig';
    n 'Heretic\'s Fork';
  };
  room 'Heretic\'s Fork' {
    s 'Spanish Tickler';
    e 'The Chair of Spikes';
  };
  room 'The Chair of Spikes' {
    w 'Heretic\'s Fork';
    e 'Blooding';
  };
  room 'Blooding' {
    w 'The Chair of Spikes'; dx=2;
    s 'Bootikens';
  };
  room 'Bootikens' {
    n 'Blooding';
    s 'Burial';
  };
  room 'Burial' {
    n 'Bootikens';
    s 'Burning';
  };
  room 'Burning' {
    n 'Burial'; dy=-1;
    w 'Cleansing the Soul';
  };
  room 'Cleansing the Soul' {
    e 'Burning';
    w 'The Ducking Stool';
    n 'The Garotte';
  };
  room 'The Ducking Stool' {
    e 'Cleansing the Soul';
  };
  room 'The Garotte' {
    s 'Cleansing the Soul';
    w 'Hanging';
  };
  room 'Hanging' {
    e 'The Garotte'; dx=-1;
    s 'Impalement' 'Steel Key';
  };
  room 'Impalement' {
    n 'Hanging';
    s 'Knotting' 'Platinum Key';
  };
  room 'Knotting' {
    n 'Impalement';
    --s -- to Iron Maiden B2
  };
}

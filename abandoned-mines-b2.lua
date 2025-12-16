region 'Abandoned Mines B2' {
  'This is a huge area which is almost completely optional; by grabbing the Mandrake Sigil from Iron Maiden B1, then cutting through City Walls East and Undercity West to Work, Then Die, you can skip right to the end.';
  -- area reachable from Undercity West
  room 'Subtellurian Horrors' {
    sw 'The Crumbling Market (South)'; dy=1.5; -- to Undercity West
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
  room 'Delusions of Happiness' {
    w 'Bandit\'s Hollow';
    enemy 'Blood Lizard';
    chest {
      'Pirate\'s Mate:Sabre Halberd.H/Sarissa Grip',
      'Heater Shield/Orion', 'Kris.D', 'Swan Song',
      'Vera Potion x3', 'Grimoire Salamandre'
    };
  };
  room 'Work, Then Die' {
    n 'Bandit\'s Hollow'; -- ONE WAY. DOES NOT UNLATCH.
    s 'Hope Obstructed'; -- to Undercity West
  };
}
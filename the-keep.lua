region "The Keep" {
  "A small area that serves to connect City Walls South (and thus Town Centre West and Snowfly Forest) to Town Centre South, but this is also the hub from which you can access the boss fight time trials.";
  room "The Soldier's Bedding" {
    w "The Boy's Training Room"; -- to City Walls South
    e "A Storm of Arrows";
    n "Stair to the Sinners" "Gold Key"; -- to Forgotten Pathway
    s "The Cage"; -- to Iron Maiden B1
  };
  room "A Storm of Arrows" {
    w "The Soldier's Bedding";
    e "Urge the Boy On";
    n "Time Trial (Minotaur)" "Kalmia Sigil";
    s "Time Trial (Dragon)" "Columbine Sigil";
  };
  room "Time Trial (Minotaur)" {
    time_trial = true;
    s "A Storm of Arrows";
    enemy "Minotaur";
  };
  room "Time Trial (Dragon)" {
    time_trial = true;
    n "A Storm of Arrows";
    enemy "Dragon";
  };
  room "Urge the Boy On" {
    w "A Storm of Arrows";
    e "A Taste of the Spoils";
    n "Time Trial (Earth Dragon)" "Anemone Sigil";
    s "Time Trial (Snow Dragon)" "Verbena Sigil";
  };
  room "Time Trial (Earth Dragon)" {
    time_trial = true;
    s "Urge the Boy On";
    enemy "Earth Dragon";
  };
  room "Time Trial (Snow Dragon)" {
    time_trial = true;
    n "Urge the Boy On";
    enemy "Snow Dragon";
  };
  room "A Taste of the Spoils" {
    w "Urge the Boy On";
    e "Wiping Blood from Blades";
    n "Time Trial (Damascus Golem)" "Schirra Sigil";
    s "Time Trial (Damascus Crab)" "Marigold Sigil";
  };
  room "Time Trial (Damascus Golem)" {
    time_trial = true;
    s "A Taste of the Spoils";
    enemy "Damascus Golem";
  };
  room "Time Trial (Damascus Crab)" {
    time_trial = true;
    n "A Taste of the Spoils";
    enemy "Damascus Crab";
  };
  room "Wiping Blood from Blades" {
    w "A Taste of the Spoils";
    e "The Warrior's Rest";
    n "Time Trial (Death + Ogre Zombie)" "Azalea Sigil";
    s "Time Trial (Asura)" "Tigertail Sigil";
  };
  room "Time Trial (Death + Ogre Zombie)" {
    time_trial = true;
    s "Wiping Blood from Blades";
    enemy "Death";
    enemy "Ogre Zombie";
  };
  room "Time Trial (Asura)" {
    time_trial = true;
    n "Wiping Blood from Blades";
    enemy "Asura";
  };
  room "The Warrior's Rest" {
    "Fight against Rosencrantz and conversation about Ashley's history.";
    w "Wiping Blood from Blades";
    s "Workshop 'Keane's Crafts'";
    n "Forcas Rise"; -- to Town Center South
    save_point = true;
    enemy "Rosencrantz" { miniboss = true };
    chest {
      locked = true;
      "Sweet Sorrow:Francisca.I/Gendarme", "Tower Shield.I/Death Queen",
      "Sallet", "Sorcerer's Reagent x3"
    };
  };
  room "Workshop 'Keane's Crafts'" {
    n "The Warrior's Rest";
    save_point = true;
    container = true;
    workshop = { "B", "I", "H" };
  };
}

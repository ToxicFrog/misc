region "Town Centre South" {
  "Another piece of connective tissue, joining the Keep, the South and East Walls, and Abandoned Mines B2 together.";
  room "Forcas Rise" {
    s "The Warrior's Rest"; dx=-3; dy=0.5; -- to The Keep
    w "Valdiman Gates";
    e "Rue Aliano";
    n "Rue Faltes";
    enemy "Crimson Blade";
  };
  room "Valdiman Gates" {
    e "Forcas Rise";
    s "The Boy's Training Room";
    save_point = true;
  };
  room "Rue Aliano" {
    w "Forcas Rise";
    e "The House Khazabas" "Mandrake Sigil";
    enemy "Crimson Blade";
  };
  room "The House Khazabas" {
    w "Rue Aliano" "Mandrake Sigil";
    n "Zebel's Walk";
    chest {
      warded = true;
      "Eye of Argon x10", "Grimoire Muet"
    };
  };
  room "Zebel's Walk" {
    s "The House Khazabas";
    e "Rue Volnac";
  };
  room "Rue Volnac" {
    w "Zebel's Walk";
    se "Train and Grow Strong"; -- to City Walls East
    -- ne "The Invaders are Found"; -- latch from City Walls East
    -- nw -- technically connects to Rue Faltes, but it's a dead end
    enemy "Crimson Blade";
  };
  room "Rue Faltes" {
    s "Forcas Rise";
    e "Rue Morgue";
  };
  room "Rue Morgue" {
    w "Rue Faltes";
    n "Corridor of Shade"; -- to Abandoned Mines B2
    enemy "Crimson Blade";
  };
}

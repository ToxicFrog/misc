region "Town Centre South" {
  "Another piece of connective tissue, joining the Keep, the South and East Walls, and Abandoned Mines B2 together.";
  room "Valdiman Gates" {
    s "The Boy's Training Room"; dx=-1; dy=1;
    e "Forcas Rise";
    save_point = true;
  };
  room "Forcas Rise" {
    w "Valdiman Gates";
    s "The Warrior's Rest"; -- to The Keep
    e "Rue Aliano";
    ne "Rue Faltes";
    enemy "Crimson Blade";
  };
  room "Rue Aliano" {
    nw "Forcas Rise";
    n "The House Khazabas" "Mandrake Sigil";
    enemy "Crimson Blade";
  };
  room "The House Khazabas" {
    s "Rue Aliano" "Mandrake Sigil";
    n "Zebel's Walk";
    chest {
      warded = true;
      "Eye of Argon x10", "Grimoire Muet"
    };
  };
  room "Zebel's Walk" {
    s "The House Khazabas"; dx=1;
    e "Rue Volnac";
  };
  room "Rue Volnac" {
    w "Zebel's Walk";
    -- se -- to City Walls East
    -- e -- to City Walls East
    -- nw -- technically connects to Rue Faltes, but it's a dead end
    enemy "Crimson Blade";
  };
  room "Rue Faltes" {
    sw "Forcas Rise";
    n "Rue Morgue";
  };
  room "Rue Morgue" {
    s "Rue Faltes";
    n "Corridor of Shade"; -- to Abandoned Mines B2
    enemy "Crimson Blade";
  };
}

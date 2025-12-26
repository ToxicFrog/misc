region "Sanctum" {
  "The last underground area before you get to Town Centre West.";
  room "Prisoners' Niche" {
    w "The Withered Spring";
    e "Corridor of the Clerics";
    enemy "Bat";
  };
  room "Corridor of the Clerics" {
    "Open hall with s in four directions.";
    w "Prisoners' Niche";
    e "Priests' Confinement";
    n "Advent Ground (South)";
    s "The Academia Corridor";
    enemy "Skeleton";
    enemy "Slime";
  };
  room "Priests' Confinement" {
    "Room full of sarcophagi.";
    w "Corridor of the Clerics";
    s "Alchemists' Laboratory";
    enemy "Bat" { "Eye of Argon" };
  };
  room "Alchemists' Laboratory" {
    "Room full of bookshelves. Access only via Priest's Confinement.";
    n "Priests' Confinement";
    w "The Academia Corridor";
    enemy "Skeleton Knight";
    enemy "Poison Slime" { "Faerie Chortle" };
    chest {
      "Bosom Cleaver:Langdebeve.B/Sand Face", "Dragonite", "Grimoire Halte"
    };
  };
  room "The Academia Corridor" {
    "Open hall with s in four directions. East exit to Alchemists' Laboratory must be unlocked from the other side.";
    n "Corridor of the Clerics";
    -- exit "Alchemists' Laboratory";
    w "Theology Classroom";
    s "Shrine of the Martyrs";
    enemy "Skeleton";
    enemy "Slime";
  };
  room "Theology Classroom" {
    "Dead end room with cage match against undead.";
    e "The Academia Corridor";
    enemy "Ghost" { "Vera Root x2" };
    enemy "Skeleton" { "Cure Bulb x2" };
  };
  room "Shrine of the Martyrs" {
    n "The Academia Corridor";
    e "Hallowed Hope";
    enemy "Skeleton Knight";
    enemy "Hellhound";
  };
  room "Hallowed Hope" {
    w "Shrine of the Martyrs";
    e "Hall of Sacrilege";
    enemy "Bat";
    enemy "Poison Slime" { "Faerie Chortle" };
  };
  room "Hall of Sacrilege" {
    w "Hallowed Hope";
    enemy "Golem" {
      boss = true;
      "Cure Bulb x2", "Elixir of Dragoons", "Grimoire Ameliorer"
    };
  };
  room "Advent Ground (South)" {
    "Large cave with a river running through it. North side accessible via Passage of the Refugees.";
    s "Corridor of the Clerics";
    e "Passage of the Refugees (South)";
    enemy "Bat";
    enemy "Lizardman";
  };
  room "Passage of the Refugees (South)" {
    "Small cave with river. North side accessible only after killing Golem in Hall of Sacrilege.";
    w "Advent Ground (South)";
    n "Passage of the Refugees (North)" "Hall of Sacrilege";
    enemy "Bat";
    enemy "Poison Slime" { "Faerie Chortle" };
  };
  room "Passage of the Refugees (North)" {
    s "Passage of the Refugees (South)" "Hall of Sacrilege";
    w "Advent Ground (North)";
    enemy "Lizardman";
  };
  room "Advent Ground (North)" {
    "North side of Advent Ground, accessed via Passage of the Refugees.";
    e "Passage of the Refugees (North)";
    n "The Cleansing Chantry";
    save_point = true;
    container = true;
  };
  room "The Cleansing Chantry" {
    "Boss fight against Dragon.";
    s "Advent Ground (North)";
    n "Stairway to the Light";
    enemy "Dragon" {
      boss = true;
      "Cure Bulb x3", "Elixir of Sages", "Grimoire Analyse"
    };
  };
  room "Stairway to the Light" {
    s "The Cleansing Chantry";
    n "Rue Vermillion"; -- to Town Center West
  };
}

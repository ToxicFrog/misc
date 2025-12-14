region "Sanctum" {
  "The last underground area before you get to Town Centre West.";
  room "Prisoners' Niche" {
    exitw "The Withered Spring";
    exite "Corridor of the Clerics";
    enemy "Bat";
  };
  room "Corridor of the Clerics" {
    "Open hall with exits in four directions.";
    exitw "Prisoners' Niche";
    exite "Priests' Confinement";
    exitn "Advent Ground (South)";
    exits "The Academia Corridor";
    enemy "Skeleton";
    enemy "Slime";
  };
  room "Priests' Confinement" {
    "Room full of sarcophagi.";
    exitw "Corridor of the Clerics";
    exits "Alchemists' Laboratory";
    enemy "Bat" { "Eye of Argon" };
  };
  room "Alchemists' Laboratory" {
    "Room full of bookshelves. Access only via Priest's Confinement.";
    exitn "Priests' Confinement";
    exitw "The Academia Corridor";
    enemy "Skeleton Knight";
    enemy "Poison Slime" { "Faerie Chortle" };
    chest {
      "Bosom Cleaver:Langdebeve.B/Sand Face", "Dragonite", "Grimoire Halte"
    };
  };
  room "The Academia Corridor" {
    "Open hall with exits in four directions. East exit to Alchemists' Laboratory must be unlocked from the other side.";
    exitn "Corridor of the Clerics";
    -- exit "Alchemists' Laboratory";
    exitw "Theology Classroom";
    exits "Shrine of the Martyrs";
    enemy "Skeleton";
    enemy "Slime";
  };
  room "Theology Classroom" {
    "Dead end room with cage match against undead.";
    exite "The Academia Corridor";
    enemy "Ghost" { "Vera Root x2" };
    enemy "Skeleton" { "Cure Bulb x2" };
  };
  room "Shrine of the Martyrs" {
    exitn "The Academia Corridor";
    exite "Hallowed Hope";
    enemy "Skeleton Knight";
    enemy "Hellhound";
  };
  room "Hallowed Hope" {
    exitw "Shrine of the Martyrs";
    exite "Hall of Sacrilege";
    enemy "Bat";
    enemy "Poison Slime" { "Faerie Chortle" };
  };
  room "Hall of Sacrilege" {
    exitw "Hallowed Hope";
    enemy "Golem" {
      boss = true;
      "Cure Bulb x2", "Elixir of Dragoons", "Grimoire Ameliorer"
    };
  };
  room "Advent Ground (South)" {
    "Large cave with a river running through it. North side accessible via Passage of the Refugees.";
    exits "Corridor of the Clerics";
    exite "Passage of the Refugees (South)";
    enemy "Bat";
    enemy "Lizardman";
  };
  room "Passage of the Refugees (South)" {
    "Small cave with river. North side accessible only after killing Golem in Hall of Sacrilege.";
    exitw "Advent Ground (South)";
    exitn "Passage of the Refugees (North)" "Hall of Sacrilege";
    enemy "Bat";
    enemy "Poison Slime" { "Faerie Chortle" };
  };
  room "Passage of the Refugees (North)" {
    exits "Passage of the Refugees (South)" "Hall of Sacrilege";
    exitw "Advent Ground (North)";
    enemy "Lizardman";
  };
  room "Advent Ground (North)" {
    "North side of Advent Ground, accessed via Passage of the Refugees.";
    exite "Passage of the Refugees (North)";
    exitn "The Cleansing Chantry";
    save_point = true;
    container = true;
  };
  room "The Cleansing Chantry" {
    "Boss fight against Dragon.";
    exits "Advent Ground (North)";
    exitn "Stairway to the Light";
    enemy "Dragon" {
      boss = true;
      "Cure Bulb x3", "Elixir of Sages", "Grimoire Analyse"
    };
  };
  room "Stairway to the Light" {
    exits "The Cleansing Chantry";
    exitn "Rue Vermillion"; -- to Town Center West
  };
}

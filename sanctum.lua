region "Sanctum" {
  [[
    The last "linear" area before you get to Town Center and the game starts to
    open up.
  ]];
  room "Prisoners' Niche" {
    exit "The Withered Spring";
    exit "Corridor of the Clerics";
    enemy "Bat";
  };
  room "Corridor of the Clerics" {
    "Open hall with exits in four directions.";
    exit "Prisoners' Niche";
    exit "Priests' Confinement";
    exit "Advent Ground (South)";
    exit "The Academia Corridor";
    enemy "Skeleton";
    enemy "Slime";
  };
  room "Priests' Confinement" {
    "Room full of sarcophagi.";
    exit "Corridor of the Clerics";
    exit "Alchemists' Laboratory";
    enemy "Bat" { "Eye of Argon" };
  };
  room "Alchemists' Laboratory" {
    "Room full of bookshelves. Access only via Priest's Confinement.";
    exit "Priests' Confinement";
    exit "The Academia Corridor";
    enemy "Skeleton Knight";
    enemy "Poison Slime" { "Faerie Chortle" };
    chest {
      "Bosom Cleaver:Langdebeve.B/Sand Face", "Dragonite", "Grimoire Halte"
    };
  };
  room "The Academia Corridor" {
    "Open hall with exits in four directions. East exit to Alchemists' Laboratory must be unlocked from the other side.";
    exit "Corridor of the Clerics";
    -- exit "Alchemists' Laboratory";
    exit "Theology Classroom";
    exit "Shrine of the Martyrs";
    enemy "Skeleton";
    enemy "Slime";
  };
  room "Theology Classroom" {
    "Dead end room with cage match against undead.";
    exit "The Academia Corridor";
    enemy "Ghost" { "Vera Root x2" };
    enemy "Skeleton" { "Cure Bulb x2" };
  };
  room "Shrine of the Martyrs" {
    exit "The Academia Corridor";
    exit "Hallowed Hope";
    enemy "Skeleton Knight";
    enemy "Hellhound";
  };
  room "Hallowed Hope" {
    exit "Shrine of the Martyrs";
    exit "Hall of Sacrilege";
    enemy "Bat";
    enemy "Poison Slime" { "Faerie Chortle" };
  };
  room "Hall of Sacrilege" {
    exit "Hallowed Hope";
    enemy "Golem" {
      boss = true;
      "Cure Bulb x2", "Elixir of Dragoons", "Grimoire Ameliorer"
    };
  };
  room "Advent Ground (South)" {
    "Large cave with a river running through it. North side accessible via Passage of the Refugees.";
    exit "Corridor of the Clerics";
    exit "Passage of the Refugees (South)";
    enemy "Bat";
    enemy "Lizardman";
  };
  room "Passage of the Refugees (South)" {
    "Small cave with river. North side accessible only after killing Golem in Hall of Sacrilege.";
    exit "Advent Ground (South)";
    exit "Passage of the Refugees (North)" "Hall of Sacrilege";
    enemy "Bat";
    enemy "Poison Slime" { "Faerie Chortle" };
  };
  room "Passage of the Refugees (North)" {
    exit "Passage of the Refugees (South)" "Hall of Sacrilege";
    exit "Advent Ground (North)";
    enemy "Lizardman";
  };
  room "Advent Ground (North)" {
    "North side of Advent Ground, accessed via Passage of the Refugees.";
    exit "Passage of the Refugees (North)";
    exit "The Cleansing Chantry";
    save_point = true;
    container = true;
  };
  room "The Cleansing Chantry" {
    "Boss fight against Dragon.";
    exit "Advent Ground (North)";
    exit "Stairway to the Light";
    enemy "Dragon" {
      boss = true;
      "Cure Bulb x3", "Elixir of Sages", "Grimoire Analyse"
    };
  };
  room "Stairway to the Light" {
    exit "The Cleansing Chantry";
    exit "Rue Vermilion"; -- to Town Center West
  };
}

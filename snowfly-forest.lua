region "Snowfly Forest" {
  "This area hates you, and does not connect up in any remotely euclidean fashion.";
  -- West side area, path to first boss.
  room "The Faerie Circle" {
    "Entrance. Cutscenes with Grissom.";
    n "Where the Hunter Climbed"; dx=-1.5; dy=-5.5; -- to Undercity West
    s "The Hunt Begins";
  };
  room "The Hunt Begins" {
    n "The Faerie Circle";
    s "Which Way Home";
  };
  room "Which Way Home" {
    "First fork in the path and the beginning of SFF proper.";
    n "The Hunt Begins";
    w "The Giving Trees";
    e "The Wounded Boar";
    s "The Birds and the Bees";
    enemy "Basilisk";
  };
  room "The Giving Trees" {
    e "Which Way Home";
    w "The Spirit Trees";
    s "They Also Feed";
    enemy "Ichthious" { "Faerie Wing" };
    enemy "Ichthious" { "Faerie Wing" };
  };
  room "The Birds and the Bees" {
    n "Which Way Home";
    w "They Also Feed";
    e "The Giving Trees";
    s "Traces of the Beast";
    enemy "Basilisk";
  };
  room "The Wounded Boar" {
    w "Which Way Home";
    e "Golden Egg Way";
    enemy "Ichthious" { "Faerie Wing" };
    enemy "Ichthious" { "Faerie Wing" };
  };
  room "Golden Egg Way" {
    w "The Wounded Boar";
    n "Traces of the Beast";
    e "Fluttering Hope";
    s "The Yellow Wood";
  };
  room "Traces of the Beast" {
    n "The Birds and the Bees";
    w "Fluttering Hope";
    e "The Yellow Wood";
    s "Golden Egg Way";
    enemy "Basilisk";
  };
  room "Fluttering Hope" {
    e "Traces of the Beast";
    w "Golden Egg Way";
    s "Return to the Land";
    enemy "Basilisk";
  };
  room "Return to the Land" {
    n "Fluttering Hope";
    s "The Spirit Trees";
    enemy "Earth Dragon" {
      "Bronze Key", "Grimoire Parebrise", "Vera Potion"
    };
  };
  room "The Yellow Wood" {
    "Progression is to the south and towards the river, but it's locked until you defeat the Earth Dragon in Return to the Land.";
    w "Traces of the Beast";
    n "Golden Egg Way";
    s "Where Soft Rains Fell" "Return to the Land";
    e "They Also Feed";
    enemy "Ichthious";
    enemy "Basilisk";
  };
  room "They Also Feed" {
    w "The Yellow Wood";
    n "The Giving Trees";
    e "The Birds and the Bees";
    s "The Spirit Trees";
  };
  room "The Spirit Trees" {
    n "They Also Feed";
    e "The Giving Trees";
  };
  -- Accessible only after defeating the boss; otherwise "a swarm of snowflies blocks the way".
  room "Where Soft Rains Fell" {
    n "The Yellow Wood" "Return to the Land";
    s "Forest River";
    enemy "Fire Elemental";
  };
  room "Forest River" {
    nw "Where Soft Rains Fell"; dx=0.5;
    n "The Faerie Circle";
    ne "Lamenting to the Moon";
    trap "Cure Panel";
    enemy "Basilisk";
    enemy "Zombie Knight";
    chest {
      "Circle Shield.H/Djinn Amber", "Knuckle Guard", "Chain Mail.I",
      "Sylphid Ring", "Nightkiller", "Acolyte's Nostrum x3",
      "Grimoire Agilite"
    }
  };
  -- Path from river to second boss and city walls south
  room "Lamenting to the Moon" {
    s "Forest River"; dx=1.5;
    w "The Silent Hedges";
    e "Howl of the Wolf King";
    n "Running with the Wolves";
    enemy "Basilisk";
  };
  room "Running with the Wolves" {
    s "Lamenting to the Moon";
    w "The Hollow Hills";
    e "You Are the Prey";
    enemy "Fire Elemental";
  };
  room "You Are the Prey" {
    w "Running with the Wolves";
    n "The Secret Path";
    e "The Silent Hedges";
    s "The Hollow Hills";
    enemy "Ichthious";
  };
  room "The Secret Path" {
    s "You Are the Prey";
    n "Hewn from Nature";
    enemy "Ichthious";
  };
  room "Hewn from Nature" {
    s "The Secret Path";
    n "The Wood Gate";
    enemy "Grissom" {
      boss = true;
      "Shillelagh:Wizard Staff.H/Sarissa Grip/Sylphid Topaz",
      "Grimoire Annuler", "Grimoire Gnome"
    };
    enemy "Dark Crusader" {
      boss = true;
      "Angel Wing:Katana.H/Cross Guard/Demonia",
      "Grimoire Deteriorer", "Elixir of Queens"
    };
    chest {
      "Corpse Reviver:Firangi.I/Cross Guard",
      "Circle Shield/Sylphid Topaz", "Demonia",
      "Vera Tonic x3", "Cure Bulb x3"
    };
  };
  room "The Wood Gate" {
    s "Hewn from Nature";
    n "The Weeping Boy"; -- to City Walls South
  };
  -- One-way paths from the east half of the woods back to the west
  room "The Wolves' Choice" {
    n "Golden Egg Way";
    w "The Woodcutter's Run";
    e "Howl of the Wolf King";
    s "They Also Feed";
  };
  room "The Woodcutter's Run" {
    w "The Birds and the Bees";
    e "The Wolves' Choice";
    s "The Yellow Wood";
    enemy "Ichthious";
  };
  room "The Hollow Hills" {
    e "Running with the Wolves";
    n "Howl of the Wolf King";
    enemy "Ichthious";
  };
  room "Howl of the Wolf King" {
    w "Lamenting to the Moon";
    e "The Silent Hedges";
    s "The Hollow Hills";
  };
  room "The Silent Hedges" {
    e "Lamenting to the Moon";
    w "The Spirit Trees";
  };
}

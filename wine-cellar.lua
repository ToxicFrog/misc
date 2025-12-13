-- Starting inventory
sphere0 {
  "Fandango:Scimitar.B/Short Hilt";
  "Bandage.L x2";
  "Bandana.L";
  "Jerkin.L";
  "Sandals.L";
  "Rood Necklace.L";
  "Cure Root x10";
  "Vera Root x10";
  "Yggdrasil's Tears x5";
  "Faerie Chortle x5";
  "Spirit Orison x5";
}

region "Wine Cellar" {
  [[
    The initial region of the game. Contains a number of one-off fights against
    Crimson Blades, along with lots of bats and wolves. Visiting the "cheap wine"
    rooms behind the Chamomile Sigil causes Zombies, Zombie Knights, Zombie Fighters,
    and Ghouls to spawn throughout the area. More generally, this is a recurring
    theme in the game -- you will encounter enemies later in the game that then
    start appearing in earlier areas if you backtrack. As far as I know, there is
    no case where you can fight those enemies "early" by hitting an event trigger
    and then backtracking, though -- the trigger is always placed at or after your
    first encounter with the enemy.
  ]];
  room "Entrance to Darkness" {
    "Starting room.";
    exit "Worker's Breakroom";
  };
  room "Worker's Breakroom" {
    "First save point and chest.";
    exit "Entrance to Darkness";
    exit "Hall of Struggle";
    save_point = true;
    chest {
      "Tovarisch:Hand Axe.B/Wooden Grip",
      "Buckler.W", "Leather Glove.L", "Vera Bulb x5", "Cure Bulb x5",
    };
    dummy "Affinity" { after = "Where Black Waters Ran"; };
  };
  room "Hall of Struggle" {
    "First enemy.";
    exit "Worker's Breakroom";
    exit "Smokebarrel Stair";
    enemy "Bat";
  };
  room "Smokebarrel Stair" {
    "Cutscene with Crimson Blades talking about the sigil-locked door.";
    exit "Hall of Struggle";
    exit "Wine Guild Hall";
    exit "Room of Cheap Red Wine" "Chamomile Sigil";
    trap "Heal Panel";
  };
  room "Wine Guild Hall" {
    "Cutscene with Crimson Blades talking about cloudstones.";
    exit "Smokebarrel Stair";
    exit "Wine Magnate's Chambers";
    save_point = true;
    container = true;
    enemy "Sackheim";
    enemy "Goodwin";
  };
  room "Wine Magnate's Chambers" {
    "Tremor cutscene.";
    exit "Wine Guild Hall";
    exit "Fine Vintage Vault";
    enemy "Bat";
    enemy "Silver Wolf";
    trap "Gust";
  };
  room "Fine Vintage Vault" {
    "Cutscene with Sydney deceiving two CBs.";
    exit "Wine Magnate's Chambers";
    exit "Chamber of Fear";
    enemy "Crimson Blade";
  };
  room "Chamber of Fear" {
    "Cutscene with earthquake raising the terrain.";
    exit "Fine Vintage Vault";
    exit "The Reckoning Room";
    exit "A Laborer's Thirst";
    enemy "Bat";
    enemy "Silver Wolf";
  };
  room "The Reckoning Room" {
    "Cage match with a bat and two wolves.";
    exit "Chamber of Fear";
    enemy "Bat";
    enemy "Silver Wolf";
    chest {
      "Seventh Heaven:Gastraph Bow.B/Simple Bolt",
      "Reinforced Glove.L",
      "Vera Root x3",
      "Cure Root x3",
    };
  };
  room "A Laborer's Thirst" {
    exit "Chamber of Fear";
    exit "The Rich Drown in Wine";
    enemy "Bat";
    enemy "Silver Wolf";
  };
  room "The Rich Drown in Wine" {
    "Lever-controlled timed door.";
    exit "A Laborer's Thirst";
    exit "Room of Rotten Grapes";
    enemy "Bat";
    enemy "Silver Wolf";
  };
  room "Room of Rotten Grapes" {
    "First flashback to Ashley's family.";
    exit "The Rich Drown in Wine";
    exit "Blackmarket of Wines";
    enemy "Bat";
    trap "Heal Panel"; -- before Lich
    trap "Curse Panel"; -- after Lich
  };
  room "Blackmarket of Wines" {
    "Small room with save point and chest. Combat dummy appears once you've defeated Minotaur.";
    exit "Room of Rotten Grapes";
    exit "The Gallows";
    save_point = true;
    chest {
      "Cure Potion",
      "Cure Bulb x5",
    };
    dummy "Human" { after = "The Gallows"; };
  };
  room "The Gallows" {
    "Minotaur boss room. 'Show me your soul' cutscene, unlocking of battle abilities.";
    exit "Blackmarket of Wines";
    enemy "Minotaur" {
      boss = true;
      "Chamomile Sigil",
      "Grimoire Guerir", -- Heal
      "Grimoire Debile", -- Degenerate
    };
    chest { "Pelta Shield.W", "Vera Bulb x3", "Yggdrasil's Tears x15", };
    -- These spawn only after you defeat the Lich and learn Teleport.
    enemy "Minotaur Zombie" {
      miniboss = true;
      after = "Bazaar of the Bizarre";
      "Rune Earrings", "Elixir of Queens", "Cure Bulb x3",
    };
    chest {
      after = "Bazaar of the Bizarre";
      locked = true;
      "Circle Shield.D/Titan Malachite", "Cure Potion x3", "Vera Potion",
    };
  };
  room "Room of Cheap Red Wine" {
    "Crimson Blade zombie cutscene.";
    exit "Smokebarrel Stair";
    exit "Room of Cheap White Wine";
    enemy "Mandel" { "Rapier:Rapier.B/Short Hilt" };
    trap "Heal Panel";
  };
  room "Room of Cheap White Wine" {
    "Cutscene with many zombies rising.";
    exit "Room of Cheap Red Wine";
    exit "The Greedy One's Den";
    enemy "Zombie Fighter" { "Cure Bulb" };
    enemy "Zombie" { "Cure Root x2" };
    enemy "Ghoul" { "Cure Root x2" };
  };
  room "The Greedy One's Den" {
    "Uninteresting room with wolves and sometimes bats.";
    exit "Room of Cheap White Wine";
    exit "The Hero's Winehall";
    enemy "Silver Wolf";
  };
  room "The Hero's Winehall" {
    exit "The Greedy One's Den";
    exit "Hall of Sworn Revenge"; -- to Catacombs
    enemy "Dullahan" {
      boss = true;
      "Elixir of Queens", "Elixir of Mages", "Grimoire Lux",
    };
    chest {
      "Rusty Nail:Spear.B/Spiculum Pole", "Braveheart", "Cure Bulb x3",
    };
  };
}

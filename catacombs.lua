region "Catacombs" {
  [[
    The second major region of the game. A lot of the enemies here are HP-dependent;
    in particular, if you can't get slimes to spawn, try again with <150HP.
  ]];
  room "Hall of Sworn Revenge" {
    "Catacombs entrance room with save point and container.";
    exit "The Hero's Winehall"; -- to Wine Cellar
    exit "The Last Blessing";
    trap "Heal Panel";
    trap "Cure Panel";
    dummy "Undead" { after = "Sanctum"; };
    save_point = true;
    container = true;
  };
  room "The Last Blessing" {
    "Bat and Slime are HP-dependent.";
    exit "Hall of Sworn Revenge";
    exit "The Weeping Corridor";
    enemy "Hellhound";
    enemy "Bat";
    enemy "Slime";
  };
  room "The Weeping Corridor" {
    "Hellhound and Slime are HP-dependent.";
    exit "The Last Blessing";
    exit "Persecution Hall";
    trap "Freeze";
    enemy "Skeleton";
    enemy "Hellhound";
    enemy "Slime";
  };
  room "Persecution Hall" {
    "Bat and Slime are HP-dependent. Exit to Rodent-Ridden Chamber by moving crates around.";
    exit "The Weeping Corridor";
    exit "Rodent-Ridden Chamber";
    exit "Shrine to the Martyrs";
    enemy "Skeleton";
    enemy "Slime";
    enemy "Bat";
  };
  room "Rodent-Ridden Chamber" {
    "Small dead end room with a chest.";
    exit "Persecution Hall";
    enemy "Skeleton";
    enemy "Ghost" { after = "The Lamenting Mother (West)"; };
    chest {
      "Pink Squirrel:Goblin Club.I/Wooden Grip",
      "Cross Guard", "Cuirass.L", "Long Boots.L",
      "Iocus", "Cure Bulb x3", "Mana Root x3",
    };
  };
  room "Shrine to the Martyrs" {
    exit "Persecution Hall";
    exit "The Lamenting Mother (West)";
    exit "Hall of Dying Hope";
    enemy "Hellhound";
    enemy "Skeleton";
    enemy "Bat";
  };
  room "The Lamenting Mother (West)" {
    "On first visit this is connected to Lamenting Mother East, so you can grab the chest there. However, after defeating the ghost and leaving, the two are no longer collected and the chest can only be reached from the other side of the room.";
    exit "Shrine to the Martyrs";
    enemy "Ghost" { "Cure Bulb x3", "Elixir of Kings", };
  };
  room "The Lamenting Mother (East)" {
    "On first visit to Lamenting Mother West, you can reach this area, but after defeating the ghost it is disconnected and reachable only via The Last Stab of Hope. The chest is thus associated with this area to avoid softlocks if you miss it on your first visit.";
    -- You can only actually use this door after triggering the quake, which means
    -- it is effectively a one-way latch from Last Stab.
    -- exit "The Last Stab of Hope";
    enemy "Ghost";
    chest {
      "Shandy Gaff:Broad Sword.B/Swept Hilt", "Knuckles.B", "Elixir of Queens",
    };
  };
  room "Hall of Dying Hope" {
    exit "Shrine to the Martyrs";
    exit "Bandits' Hideout";
    exit "The Bloody Hallway";
    enemy "Zombie Knight";
    enemy "Slime";
    enemy "Skeleton";
  };
  room "Bandits' Hideout" {
    "Dead-end treasure room. Ghost has a high chance of dropping a Fireball grimoire.";
    exit "Hall of Dying Hope";
    enemy "Hellhound";
    enemy "Bat";
    enemy "Ghost";
    chest {
      "Soul Kiss:Scramasax.S/Swept Hilt", "Targe.B", "Knuckles.B", "Bear Mask.L",
      "Haeralis", "Spirit Orison x3", "Eye of Argon x3"
    };
  };
  room "The Bloody Hallway" {
    "Room with simple block-pushing puzzle.";
    exit "Hall of Dying Hope";
    exit "Faith Overcame Fear";
  };
  room "Faith Overcame Fear" {
    exit "The Bloody Hallway";
    exit "The Withered Spring";
    enemy "Skeleton";
    enemy "Zombie Knight";
    enemy "Slime";
  };
  room "The Withered Spring" {
    exit "Faith Overcame Fear";
    exit "Prisoners' Niche" "Lily Sigil"; -- to Sanctum
    exit 'Workshop "Work of Art"';
    exit "Repent, O ye Sinners";
    enemy "Zombie Knight";
    enemy "Ghoul";
    save_point = true;
  };
  room 'Workshop "Work of Art"' {
    "First workshop!";
    exit "The Withered Spring";
    save_point = true;
    container = true;
    workshop = { "W", "L", "B" };
  };
  room "Repent, O ye Sinners" {
    exit "The Withered Spring";
    exit "The Reaper's Victims";
    exit "The Last Stab of Hope";
    enemy "Bat";
    enemy "Mummy";
    enemy "Slime";
  };
  room "The Reaper's Victims" {
    exit "Repent, O ye Sinners";
    enemy "Zombie Knight";
    enemy "Bat";
  };
  room "The Last Stab of Hope" {
    "Vertical cliff to the north can be traversed by breaking the heavy crate, then carrying the light ones. This is the room connected to the west half of Lamenting Mother.";
    exit "Repent, O ye Sinners";
    exit "The Lamenting Mother (East)";
    exit "Hallway of Heroes";
    trap "Cure Panel";
    enemy "Skeleton";
    enemy "Slime";
  };
  room "Hallway of Heroes" {
    exit "The Last Stab of Hope";
    exit "The Beast's Domain";
    enemy "Zombie Knight";
  };
  room "The Beast's Domain" {
    "Miniboss fight against two Lizardmen for the Lily Sigil.";
    exit "Hallway of Heroes";
    enemy "Lizardman" {
      miniboss = true;
      "Knuckles.I", "Glaive:Glaive.B/Wooden Pole", "Grimoire Antidote", "Elixir of Queens",
    };
    enemy "Lizardman" {
      miniboss = true;
      "Cuirass.L", "Spear/Spear.I/Spiculum Pole", "Lily Sigil",
    };
  }
}
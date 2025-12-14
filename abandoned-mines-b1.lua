region "Abandoned Mines B1" {
  room "Dreamers' Entrance" {
    "First encounter with Stirges, bloodsucking bats";
    exitn "Where the Master Fell"; dy = -7; -- to City Walls West
    exits "The Crossing";
    enemy "Stirge";
  };
  room "The Crossing" {
    exitn "Dreamers' Entrance";
    exitw "Miners' Resting Hall";
    exite "Conflict and Accord";
    exits "The Suicide King";
    save_point = true;
    enemy "Hellhound";
  };
  room "Miners' Resting Hall" {
    "First mimic. Extremely annoying and doesn't even drop anything! Also first locked chest; requires the Unlock spell from Grimoire Clef.";
    exite "The Crossing";
    enemy "Goblin";
    enemy "Mimic";
    chest {
      warded = true;
      "Stinger:Guisarm.B/Sand Face", "Quad Shield.B/Salamander Ruby",
      "Ring Mail.B", "Ring Leggings.B", "White Queen", "Grimoire Visible",
      "Cure Bulb x5"
    };
  };
  room "Conflict and Accord" {
    exitw "The Crossing";
    exits "The End of the Line";
    enemy "Hellhound";
    enemy "Goblin";
  };
  room "The End of the Line" {
    "Locked-door battle against goblins.";
    exitn "Conflict and Accord"; dy = -2;
    exits "The Earthquake's Mark";
    enemy "Stirge" { "Vera Root" };
    enemy "Goblin" { "Yggdrasil's Tears" };
    enemy "Goblin" { "Yggdrasil's Tears" };
  };
  room "The Earthquake's Mark" {
    "Extremely vertical room full of stirges. Upper level (N/E) doors are unlocked. Lower level W door is latched from the other side and must be reached by going S from The Crossing; S door is sigil-locked";
    exitn "The End of the Line";
    exite "Coal Mine Storage";
    exits "The Passion of Lovers" "Hyacinth Sigil";
    -- exit "The Fruits of Friendship"; -- one-way
    enemy "Stirge";
    trap "Eruption";
  };
  room "Coal Mine Storage" {
    "Dead-end room notable for Fern Sigil and a goblin leader.";
    exitw "The Earthquake's Mark";
    enemy "Goblin";
    enemy "Goblin Leader";
    trap "Poison Panel";
    trap "Trap Clear";
    chest {
      "Ring Sleeve.B", "Chain Coif.B", "Undine Jasper", "Fern Sigil"
    };
  };
  room "The Suicide King" {
    exitn "The Crossing";
    exits "The Battle's Beginning";
    enemy "Stirge" { "Vera Root" };
    enemy "Goblin" { "Yggdrasil's Tears" };
    enemy "Goblin" { "Yggdrasil's Tears" };
  };
  room "The Battle's Beginning" {
    "Boss fight against the Wyvern.";
    exitn "The Suicide King";
    exits "What Lies Ahead";
    enemy "Wyvern" {
      boss = true;
      "Hyacinth Sigil", "Cure Tonic", "Grimoire Ignifuge"
    };
  };
  room "What Lies Ahead?" {
    exitn "The Battle's Beginning";
    exits "The Fruits of Friendship";
    enemy "Goblin";
    enemy "Goblin Leader";
    trap "Heal Panel";
  };
  room "The Fruits of Friendship" {
    exitn "What Lies Ahead";
    exite "The Earthquake's Mark";
  };
  room "The Passion of Lovers" {
    "Entering here starts a timer to get through this and Hall of Hope to Dark Tunnel.";
    exitn "The Earthquake's Mark";
    exite "The Hall of Hope";
  };
  room "The Hall of Hope" {
    exitw "The Passion of Lovers";
    exite "The Dark Tunnel";
    enemy "Hellhound";
  };
  room "The Dark Tunnel" {
    "Four-way room with save point.";
    save_point = true;
    exitw "The Hall of Hope";
    exitn "Everwant Passage";
    exite "Rust in Peace";
    exits "The Smeltry";
    enemy "Goblin";
    enemy "Goblin Leader";
    dummy "Beast" { after = "Hewn from Nature" };
  };
  room "Everwant Passage" {
    "Another mimic room, and you can't even get through it until NG+.";
    exits "The Dark Tunnel"; dy = 1;
    exitw "Mining Regrets" "Silver Key";
    enemy "Goblin";
    enemy "Mimic";
  };
  room "Mining Regrets" {
    "Dead-end room with some nice NG+ gear.";
    exite "Everwant Passage";
    trap "Death Vapor";
    chest {
      "White Cargo:Voulge.D/Winged Pole", "Polaris", "Mana Potion x3"
    };
  };
  room "Rust in Peace" {
    exitw "The Dark Tunnel";
    enemy "Mimic";
    enemy "Goblin";
    enemy "Goblin Leader";
    chest {
      warded = true;
      "Chain Sleeve.B", "Salamander Ring", "Manabreaker", "Elixir of Sages", "Grimoire Undine"
    };
  };
  room "The Smeltry" {
    exitn "The Dark Tunnel";
    exits "Clash of Hyaenas";
    enemy "Fire Elemental" {
      boss = true;
      "Grimoire Flamme", "Elixir of Queens", "Mana Tonic"
    };
  };
  room "Clash of Hyaenas" {
    exitn "The Smeltry";
    exite "Greed Knows No Bounds";
  };
  room "Greed Knows No Bounds" {
    exitw "Clash of Hyaenas";
    exite "Live Long and Prosper";
    enemy "Goblin";
    enemy "Goblin Leader";
  };
  room "Live Long and Prosper" {
    exitw "Greed Knows No Bounds";
    exitn "Pray to the Mineral Gods" "Fern Sigil";
  };
  room "Pray to the Mineral Gods" {
    exits "Live Long and Prosper";
    exitn "Traitor's Parting";
    enemy "Stirge";
  };
  room "Traitor's Parting" {
    "Boss fight against Ogre, and cutscene of Sydney, Hardin, and Merlose in Dinas Walk.";
    exits "Pray to the Mineral Gods";
    exitn "Escapeway";
    enemy "Ogre" {
      boss = true;
      "Cure Bulb x3", "Elixir of Kings", "Grimoire Rempart"
    };
  };
  room "Escapeway" {
    exits "Traitor's Parting";
    exitn "Rue Bouquet"; -- to Town Centre West
  };
}

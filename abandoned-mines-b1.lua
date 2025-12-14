region "Abandoned Mines B1" {
  room "Dreamers' Entrance" {
    "First encounter with Stirges, bloodsucking bats";
    exit "Where the Master Fell"; -- to City Walls West
    exit "The Crossing";
    enemy "Stirge";
  };
  room "The Crossing" {
    exit "Dreamers' Entrance";
    exit "Miners' Resting Hall";
    exit "Conflict and Accord";
    exit "The Suicide King";
    save_point = true;
    enemy "Hellhound";
  };
  room "Miners' Resting Hall" {
    "First mimic. Extremely annoying and doesn't even drop anything! Also first locked chest; requires the Unlock spell from Grimoire Clef.";
    exit "The Crossing";
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
    exit "The Crossing";
    exit "The End of the Line";
    enemy "Hellhound";
    enemy "Goblin";
  };
  room "The End of the Line" {
    "Locked-door battle against goblins.";
    exit "Conflict and Accord";
    exit "The Earthquake's Mark";
    enemy "Stirge" { "Vera Root" };
    enemy "Goblin" { "Yggdrasil's Tears" };
    enemy "Goblin" { "Yggdrasil's Tears" };
  };
  room "The Earthquake's Mark" {
    "Extremely vertical room full of stirges. Upper level (N/E) doors are unlocked. Lower level W door is latched from the other side and must be reached by going S from The Crossing; S door is sigil-locked";
    exit "The End of the Line";
    exit "Coal Mine Storage";
    exit "The Passion of Lovers" "Hyacinth Sigil";
    -- exit "The Fruits of Friendship"; -- one-way
    enemy "Stirge";
    trap "Eruption";
  };
  room "Coal Mine Storage" {
    "Dead-end room notable for Fern Sigil and a goblin leader.";
    exit "The Earthquake's Mark";
    enemy "Goblin";
    enemy "Goblin Leader";
    trap "Poison Panel";
    trap "Trap Clear";
    chest {
      "Ring Sleeve.B", "Chain Coif.B", "Undine Jasper", "Fern Sigil"
    };
  };
  room "The Suicide King" {
    exit "The Crossing";
    exit "The Battle's Beginning";
    enemy "Stirge" { "Vera Root" };
    enemy "Goblin" { "Yggdrasil's Tears" };
    enemy "Goblin" { "Yggdrasil's Tears" };
  };
  room "The Battle's Beginning" {
    "Boss fight against the Wyvern.";
    exit "The Suicide King";
    exit "What Lies Ahead";
    enemy "Wyvern" {
      boss = true;
      "Hyacinth Sigil", "Cure Tonic", "Grimoire Ignifuge"
    };
  };
  room "What Lies Ahead?" {
    exit "The Battle's Beginning";
    exit "The Fruits of Friendship";
    enemy "Goblin";
    enemy "Goblin Leader";
    trap "Heal Panel";
  };
  room "The Fruits of Friendship" {
    exit "What Lies Ahead";
    exit "The Earthquake's Mark";
  };
  room "The Passion of Lovers" {
    "Entering here starts a timer to get through this and Hall of Hope to Dark Tunnel.";
    exit "The Earthquake's Mark";
    exit "The Hall of Hope";
  };
  room "The Hall of Hope" {
    exit "The Passion of Lovers";
    exit "The Dark Tunnel";
    enemy "Hellhound";
  };
  room "The Dark Tunnel" {
    "Four-way room with save point.";
    save_point = true;
    exit "The Hall of Hope";
    exit "Everwant Passage";
    exit "Rust in Peace";
    exit "The Smeltry";
    enemy "Goblin";
    enemy "Goblin Leader";
    dummy "Beast" { after = "Hewn from Nature" };
  };
  room "Everwant Passage" {
    "Another mimic room, and you can't even get through it until NG+.";
    exit "The Dark Tunnel";
    exit "Mining Regrets" "Silver Key";
    enemy "Goblin";
    enemy "Mimic";
  };
  room "Mining Regrets" {
    "Dead-end room with some nice NG+ gear.";
    exit "Everwant Passage";
    trap "Death Vapor";
    chest {
      "White Cargo:Voulge.D/Winged Pole", "Polaris", "Mana Potion x3"
    };
  };
  room "Rust in Peace" {
    exit "The Dark Tunnel";
    enemy "Mimic";
    enemy "Goblin";
    enemy "Goblin Leader";
    chest {
      warded = true;
      "Chain Sleeve.B", "Salamander Ring", "Manabreaker", "Elixir of Sages", "Grimoire Undine"
    };
  };
  room "The Smeltry" {
    exit "The Dark Tunnel";
    exit "Clash of Hyaenas";
    enemy "Fire Elemental" {
      boss = true;
      "Grimoire Flamme", "Elixir of Queens", "Mana Tonic"
    };
  };
  room "Clash of Hyaenas" {
    exit "The Smeltry";
    exit "Greed Knows No Bounds";
  };
  room "Greed Knows No Bounds" {
    exit "Clash of Hyaenas";
    exit "Live Long and Prosper";
    enemy "Goblin";
    enemy "Goblin Leader";
  };
  room "Live Long and Prosper" {
    exit "Greed Knows No Bounds";
    exit "Pray to the Mineral Gods" "Fern Sigil";
  };
  room "Pray to the Mineral Gods" {
    exit "Live Long and Prosper";
    exit "Traitor's Parting";
    enemy "Stirge";
  };
  room "Traitor's Parting" {
    "Boss fight against Ogre, and cutscene of Sydney, Hardin, and Merlose in Dinas Walk.";
    exit "Pray to the Mineral Gods";
    exit "Escapeway";
    enemy "Ogre" {
      boss = true;
      "Cure Bulb x3", "Elixir of Kings", "Grimoire Rempart"
    };
  };
  room "Escapeway" {
    exit "Traitor's Parting";
    exit "Rue Bouquet"; -- to Town Centre West
  };
}

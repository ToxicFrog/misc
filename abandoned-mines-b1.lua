region "Abandoned Mines B1" {
  room "Dreamers' Entrance" {
    "First encounter with Stirges, bloodsucking bats";
    n "Where the Master Fell"; dy = -7; -- to City Walls West
    s "The Crossing";
    enemy "Stirge";
  };
  room "The Crossing" {
    n "Dreamers' Entrance";
    w "Miners' Resting Hall";
    e "Conflict and Accord";
    s "The Suicide King";
    save_point = true;
    enemy "Hellhound";
  };
  room "Miners' Resting Hall" {
    "First mimic. Extremely annoying and doesn't even drop anything! Also first locked chest; requires the Unlock spell from Grimoire Clef.";
    e "The Crossing";
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
    w "The Crossing";
    s "The End of the Line";
    enemy "Hellhound";
    enemy "Goblin";
  };
  room "The End of the Line" {
    "Locked-door battle against goblins.";
    n "Conflict and Accord"; dy = -2;
    s "The Earthquake's Mark";
    enemy "Stirge" { "Vera Root" };
    enemy "Goblin" { "Yggdrasil's Tears" };
    enemy "Goblin" { "Yggdrasil's Tears" };
  };
  room "The Earthquake's Mark" {
    "Extremely vertical room full of stirges. Upper level (N/E) doors are unlocked. Lower level W door is latched from the other side and must be reached by going S from The Crossing; S door is sigil-locked";
    n "The End of the Line";
    e "Coal Mine Storage";
    s "The Passion of Lovers" "Hyacinth Sigil";
    -- w "The Fruits of Friendship"; -- latch
    enemy "Stirge";
    trap "Eruption";
  };
  room "Coal Mine Storage" {
    "Dead-end room notable for Fern Sigil and a goblin leader.";
    w "The Earthquake's Mark";
    enemy "Goblin";
    enemy "Goblin Leader";
    trap "Poison Panel";
    trap "Trap Clear";
    chest {
      "Ring Sleeve.B", "Chain Coif.B", "Undine Jasper", "Fern Sigil"
    };
  };
  room "The Suicide King" {
    n "The Crossing";
    s "The Battle's Beginning";
    enemy "Stirge" { "Vera Root" };
    enemy "Goblin" { "Yggdrasil's Tears" };
    enemy "Goblin" { "Yggdrasil's Tears" };
  };
  room "The Battle's Beginning" {
    "Boss fight against the Wyvern.";
    n "The Suicide King";
    s "What Lies Ahead?";
    enemy "Wyvern" {
      boss = true;
      "Hyacinth Sigil", "Cure Tonic", "Grimoire Ignifuge"
    };
  };
  room "What Lies Ahead?" {
    n "The Battle's Beginning";
    s "The Fruits of Friendship";
    enemy "Goblin";
    enemy "Goblin Leader";
    trap "Heal Panel";
  };
  room "The Fruits of Friendship" {
    n "What Lies Ahead?";
    e "The Earthquake's Mark";
  };
  room "The Passion of Lovers" {
    "Entering here starts a timer to get through this and Hall of Hope to Dark Tunnel.";
    n "The Earthquake's Mark";
    e "The Hall of Hope";
  };
  room "The Hall of Hope" {
    w "The Passion of Lovers";
    e "The Dark Tunnel";
    enemy "Hellhound";
  };
  room "The Dark Tunnel" {
    "Four-way room with save point.";
    save_point = true;
    w "The Hall of Hope";
    n "Everwant Passage";
    e "Rust in Peace";
    s "The Smeltry";
    enemy "Goblin";
    enemy "Goblin Leader";
    dummy "Beast" { after = "Hewn from Nature" };
  };
  room "Everwant Passage" {
    "Another mimic room, and you can't even get through it until NG+.";
    s "The Dark Tunnel"; dy = 1;
    w "Mining Regrets" "Silver Key";
    enemy "Goblin";
    enemy "Mimic";
  };
  room "Mining Regrets" {
    "Dead-end room with some nice NG+ gear.";
    e "Everwant Passage";
    trap "Death Vapor";
    chest {
      "White Cargo:Voulge.D/Winged Pole", "Polaris", "Mana Potion x3"
    };
  };
  room "Rust in Peace" {
    w "The Dark Tunnel";
    enemy "Mimic";
    enemy "Goblin";
    enemy "Goblin Leader";
    chest {
      warded = true;
      "Chain Sleeve.B", "Salamander Ring", "Manabreaker", "Elixir of Sages", "Grimoire Undine"
    };
  };
  room "The Smeltry" {
    n "The Dark Tunnel";
    s "Clash of Hyaenas";
    enemy "Fire Elemental" {
      boss = true;
      "Grimoire Flamme", "Elixir of Queens", "Mana Tonic"
    };
  };
  room "Clash of Hyaenas" {
    n "The Smeltry";
    e "Greed Knows No Bounds";
  };
  room "Greed Knows No Bounds" {
    w "Clash of Hyaenas";
    e "Live Long and Prosper";
    enemy "Goblin";
    enemy "Goblin Leader";
  };
  room "Live Long and Prosper" {
    w "Greed Knows No Bounds";
    n "Pray to the Mineral Gods" "Fern Sigil";
  };
  room "Pray to the Mineral Gods" {
    s "Live Long and Prosper";
    n "Traitor's Parting";
    enemy "Stirge";
  };
  room "Traitor's Parting" {
    "Boss fight against Ogre, and cutscene of Sydney, Hardin, and Merlose in Dinas Walk.";
    s "Pray to the Mineral Gods";
    n "Escapeway";
    enemy "Ogre" {
      boss = true;
      "Cure Bulb x3", "Elixir of Kings", "Grimoire Rempart"
    };
  };
  room "Escapeway" {
    s "Traitor's Parting";
    n "Rue Bouquet"; -- to Town Centre West
  };
}

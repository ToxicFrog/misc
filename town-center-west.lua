region "Town Center West" {
  "The first Town Center area you gain access to, but most of it is inaccessible until you activate the cloudstone at Tircolas Flow.";
  room "Rue Vermillion" {
    "East takes you to the workshop, south to a boss.";
    exit "Stairway to the Light"; -- to Sanctum
    exit "Tircolas Flow (North)";
    exit "The Rene Coastroad";
    exit "Students of Death" "Crimson Key"; -- to City Walls West
    save_point = true;
  };
  room "The Rene Coastroad" {
    exit "Rue Vermillion";
    exit 'Workshop "Magic Hammer"';
    exit "Rue Mal Fallde";
    trap "Heal Panel";
  };
  room 'Workshop "Magic Hammer"' {
    "Second workshop, and the first place you can create Hagane items.";
    exit "The Rene Coastroad";
    save_point = true;
    container = true;
    workshop = { "B", "I" };
  };
  room "Rue Mal Fallde" {
    exit "The Rene Coastroad";
    exit "Tircolas Flow (North)";
  };
  room "Tircolas Flow (North)" {
    "'Incomplete death' cutscene. Crossing the river requires activating the cloudstone from the south shore first.";
    exit "Rue Vermillion";
    exit "Rue Mal Fallde";
    exit "Tircolas Flow (South)" "Tircolas Flow (South)";
    enemy "Duane" {
      boss = true;
      "Wizard Robe.L", "Magnolia Frau:Wizard Staff/Sand Face",
      "Crimson Key", "Grimoire Demolir", "Grimoire Clef",
    };
    enemy "Sarjik" {
      "Rapier.I/Cross Guard", "Mana Root x3"
    };
    enemy "Bejart" {
      "Guisarm.B/Czekan Type", "Cure Root x3"
    };
  };
  room "Tircolas Flow (South)" {
    exit "Tircolas Flow (North)";
    exit "Rue Bouquet";
    exit "Glacialdra Kirk Ruins";
    enemy "Crimson Blade";
  };
  room "Rue Bouquet" {
    exit "Escapeway"; -- to room in Abandoned Mines B1, not the area of the same name.
    exit "Tircolas Flow (South)";
    exit "Glacialdra Kirk Ruins";
  };
  room "Glacialdra Kirk Ruins" {
    "Notable primarily for containing the first 'Sealed with the Rood Inverse' door; in normal play you can't traverse this until NG+.";
    exit "Tircolas Flow (South)";
    exit "Rue Bouquet";
    exit "Rue Sant D'alsa";
    exit "Path to the Greengrocer" "Rood Inverse"; -- to Undercity West; NG+ only
  };
  room "Rue Sant D'alsa" {
    "Cutscene in Villeport Way featuring Sydney, Guildenstern, and Samantha talking about the Gran Grimoire.";
    exit "Glacialdra Kirk Ruins";
    exit "Dinas Walk";
    exit "Villeport Way";
    enemy "Crimson Blade";
  };
  room "Dinas Walk" {
    "Second floor area connecting St. D'alsa to Villeport.";
    exit "Rue Sant D'alsa";
    exit "Villeport Way";
  };
  room "Villeport Way" {
    exit "Dinas Walk";
    exit "Rue Sant D'alsa";
    -- exit "In Wait of the Foe"; -- One-way from City Walls South
    exit "The Bread Peddler's Way"; -- to Undercity West
  };
}

region "Town Center West" {
  "The first Town Center area you gain access to, but most of it is inaccessible until you activate the cloudstone at Tircolas Flow.";
  room "Rue Vermillion" {
    "East takes you to the workshop, south to a boss.";
    exitsw "Stairway to the Light"; -- to Sanctum
    exits "Tircolas Flow (North)";
    exite "The Rene Coastroad";
    exitw "Students of Death" "Crimson Key"; -- to City Walls West
    save_point = true;
  };
  room "The Rene Coastroad" {
    exitw "Rue Vermillion";
    exits 'Workshop "Magic Hammer"';
    exitse "Rue Mal Fallde";
    trap "Heal Panel";
  };
  room 'Workshop "Magic Hammer"' {
    "Second workshop, and the first place you can create Hagane items.";
    exitn "The Rene Coastroad";
    save_point = true;
    container = true;
    workshop = { "B", "I" };
  };
  room "Rue Mal Fallde" {
    exitnw "The Rene Coastroad";
    exits "Tircolas Flow (North)";
  };
  room "Tircolas Flow (North)" {
    "'Incomplete death' cutscene. Crossing the river requires activating the cloudstone from the south shore first.";
    exitne "Rue Mal Fallde";
    exitnw "Rue Vermillion";
    exits "Tircolas Flow (South)" "Tircolas Flow (South)";
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
    exitn "Tircolas Flow (North)";
    exitse "Rue Bouquet";
    exitsw "Glacialdra Kirk Ruins";
    enemy "Crimson Blade";
  };
  room "Rue Bouquet" {
    exitnw "Tircolas Flow (South)";
    exits "Escapeway"; -- to room in Abandoned Mines B1, not the area of the same name.
    exitw "Glacialdra Kirk Ruins";
  };
  room "Glacialdra Kirk Ruins" {
    "Notable primarily for containing the first 'Sealed with the Rood Inverse' door; in normal play you can't traverse this until NG+.";
    exitn "Tircolas Flow (South)";
    exite "Rue Bouquet";
    exits "Rue Sant D'alsa";
    exitw "Path to the Greengrocer" "Rood Inverse"; -- to Undercity West; NG+ only
  };
  room "Rue Sant D'alsa" {
    "Cutscene in Villeport Way featuring Sydney, Guildenstern, and Samantha talking about the Gran Grimoire.";
    exitn "Glacialdra Kirk Ruins"; dy = -3;
    exitw "Dinas Walk";
    exitsw "Villeport Way";
    enemy "Crimson Blade";
  };
  room "Dinas Walk" {
    "Second floor area connecting St. D'alsa to Villeport.";
    exite "Rue Sant D'alsa";
    exitw "Villeport Way";
  };
  room "Villeport Way" {
    exite "Dinas Walk";
    exitse "Rue Sant D'alsa";
    -- exit "In Wait of the Foe"; -- One-way from City Walls South
    exitn "The Bread Peddler's Way"; -- to Undercity West
    enemy "Crimson Blade";
  };
}

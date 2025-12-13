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
  room "Tircolas Flow (South)" {};
  room "Rue Bouquet" {};
  room "Glacialdra Kirk Ruins" {};
  room "Rue Sant D'alsa" {};
  room "Dinas Walk" {};
  room "Villeport Way" {};
}

region "Town Center West" {
  "The first Town Center area you gain access to, but most of it is inaccessible until you activate the cloudstone at Tircolas Flow.";
  room "Rue Vermillion" {
    "East takes you to the workshop, south to a boss.";
    sw "Stairway to the Light"; -- to Sanctum
    s "Tircolas Flow (North)";
    e "The Rene Coastroad";
    w "Students of Death" "Crimson Key"; -- to City Walls West
    save_point = true;
  };
  room "The Rene Coastroad" {
    w "Rue Vermillion";
    s 'Workshop "Magic Hammer"';
    se "Rue Mal Fallde";
    trap "Heal Panel";
  };
  room 'Workshop "Magic Hammer"' {
    "Second workshop, and the first place you can create Hagane items.";
    n "The Rene Coastroad";
    save_point = true;
    container = true;
    workshop = { "B", "I" };
  };
  room "Rue Mal Fallde" {
    nw "The Rene Coastroad";
    s "Tircolas Flow (North)";
  };
  room "Tircolas Flow (North)" {
    "'Incomplete death' cutscene. Crossing the river requires activating the cloudstone from the south shore first.";
    ne "Rue Mal Fallde";
    nw "Rue Vermillion";
    s "Tircolas Flow (South)" "Tircolas Flow (South)";
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
    n "Tircolas Flow (North)";
    se "Rue Bouquet";
    sw "Glacialdra Kirk Ruins";
    enemy "Crimson Blade";
  };
  room "Rue Bouquet" {
    nw "Tircolas Flow (South)";
    s "Escapeway"; -- to room in Abandoned Mines B1, not the area of the same name.
    w "Glacialdra Kirk Ruins";
  };
  room "Glacialdra Kirk Ruins" {
    "Notable primarily for containing the first 'Sealed with the Rood Inverse' door; in normal play you can't traverse this until NG+.";
    n "Tircolas Flow (South)";
    e "Rue Bouquet";
    s "Rue Sant D'alsa";
    w "Path to the Greengrocer" "Rood Inverse"; -- to Undercity West; NG+ only
  };
  room "Rue Sant D'alsa" {
    "Cutscene in Villeport Way featuring Sydney, Guildenstern, and Samantha talking about the Gran Grimoire.";
    n "Glacialdra Kirk Ruins"; dy = -3;
    w "Dinas Walk";
    sw "Villeport Way";
    enemy "Crimson Blade";
  };
  room "Dinas Walk" {
    "Second floor area connecting St. D'alsa to Villeport.";
    e "Rue Sant D'alsa";
    w "Villeport Way";
  };
  room "Villeport Way" {
    e "Dinas Walk";
    se "Rue Sant D'alsa";
    -- exit "In Wait of the Foe"; -- One-way from City Walls South
    n "The Bread Peddler's Way"; -- to Undercity West
    enemy "Crimson Blade";
  };
}

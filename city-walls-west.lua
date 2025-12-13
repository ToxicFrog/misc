region "City Walls West" {
  "Tiny area reachable from City Center West with the Crimson Key, granting access to Abandoned Mines B1.";
  room "Students of Death" {
    exit "Rue Vermillion" "Crimson Key"; -- to City Center West
    exit "The Gabled Hall";
  };
  room "The Gabled Hall" {
    exit "Students of Death";
    exit "Where the Master Fell";
    enemy "Zombie Knight";
    enemy "Zombie Fighter";
  };
  room "Where the Master Fell" {
    exit "The Gabled Hall";
    exit "Dreamers' Entrance"; -- to Abandoned Mines B1
  };
}

region "City Walls West" {
  "Tiny area reachable from City Center West with the Crimson Key, granting access to Abandoned Mines B1.";
  room "Students of Death" {
    e "Rue Vermillion" "Crimson Key"; dx = -1; -- to City Center West
    s "The Gabled Hall";
  };
  room "The Gabled Hall" {
    n "Students of Death";
    s "Where the Master Fell";
    enemy "Zombie Knight";
    enemy "Zombie Fighter";
  };
  room "Where the Master Fell" {
    n "The Gabled Hall";
    s "Dreamers' Entrance"; -- to Abandoned Mines B1
  };
}

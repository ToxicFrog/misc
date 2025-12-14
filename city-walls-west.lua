region "City Walls West" {
  "Tiny area reachable from City Center West with the Crimson Key, granting access to Abandoned Mines B1.";
  room "Students of Death" {
    exite "Rue Vermillion" "Crimson Key"; dx = -1; -- to City Center West
    exits "The Gabled Hall";
  };
  room "The Gabled Hall" {
    exitn "Students of Death";
    exits "Where the Master Fell";
    enemy "Zombie Knight";
    enemy "Zombie Fighter";
  };
  room "Where the Master Fell" {
    exitn "The Gabled Hall";
    exits "Dreamers' Entrance"; -- to Abandoned Mines B1
  };
}

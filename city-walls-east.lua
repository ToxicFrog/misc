region "City Walls East" {
  "Small area linking Town Centre South to southwest Undercity West. In NG+ this is also the access to Snowfly Forest East.";
  room "Train and Grow Strong" {
    nw "Rue Volnac"; dx=1; dy=-2.5; -- to City Centre South
    n "The Squire's Gathering";
    s "Steady the Boar-Spears" "Rood Inverse"; -- to Snowfly Forest East
  };
  room "The Squire's Gathering" {
    s "Train and Grow Strong";
    n "The Invaders are Found";
    enemy "Zombie Mage";
    enemy "Dark Skeleton";
  };
  room "The Invaders are Found" {
    s "The Squire's Gathering";
    sw "Rue Volnac"; -- latch to City Centre South
    n "The Dream Weavers";
    enemy "Dark Skeleton";
  };
  room "The Dream Weavers" {
    s "The Invaders are Found";
    n "The Cornered Savage";
    enemy "Zombie Mage";
    enemy "Dark Skeleton";
  };
  room "The Cornered Savage" {
    s "The Dream Weavers";
    n "Fear of the Fall"; -- to Undercity West
    enemy "Gargoyle";
  };
}

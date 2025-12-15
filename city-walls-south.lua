region "City Walls South" {
  "A small area interconnecting Snowfly Forest, City Walls West, Town Center South, and The Keep.";
  room "The Weeping Boy" {
    s "The Wood Gate"; -- to Snowfly Forest
    e "Swords for the Land";
    enemy "Lizardman";
  };
  room "Swords for the Land" {
    w "The Weeping Boy";
    e "In Wait of the Foe";
    enemy "Lizardman";
    enemy "Blood Lizard";
  };
  room "In Wait of the Foe" {
    w "Swords for the Land";
    e "Where Weary Riders Rest";
    n "Villeport Way"; -- to Town Centre West
  };
  room "Where Weary Riders Rest" {
    w "In Wait of the Foe";
    e "The Boy's Training Room";
    enemy "Lizardman";
  };
  room "The Boy's Training Room" {
    w "Where Weary Riders Rest";
    e "The Soldier's Bedding"; -- to The Keep
    -- n ""; -- one-way from Town Center South
    enemy "Lizardman";
    enemy "Blood Lizard";
    dummy "Dragon" { after = "Dining in Darkness" };
  };
}
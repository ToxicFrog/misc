region "City Walls South" {
  "A small area interconnecting Snowfly Forest, City Walls West, Town Center South, and The Keep.";
  room "In Wait of the Foe" {
    n "Villeport Way"; dx=2; dy=-0.5; -- latch to Town Centre West
    w "Swords for the Land";
    e "Where Weary Riders Rest";
  };
  room "Swords for the Land" {
    e "In Wait of the Foe";
    w "The Weeping Boy";
    enemy "Lizardman";
    enemy "Blood Lizard";
  };
  room "The Weeping Boy" {
    e "Swords for the Land";
    s "The Wood Gate"; -- to Snowfly Forest
    enemy "Lizardman";
  };
  room "Where Weary Riders Rest" {
    w "In Wait of the Foe";
    e "The Boy's Training Room";
    enemy "Lizardman";
  };
  room "The Boy's Training Room" {
    w "Where Weary Riders Rest";
    e "The Soldier's Bedding"; -- to The Keep
    -- n ""; -- latch from Town Center South
    enemy "Lizardman";
    enemy "Blood Lizard";
    dummy "Dragon" { after = "Dining in Darkness" };
  };
}

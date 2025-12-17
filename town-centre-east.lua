region "Town Centre East" {
  "The final hub area of the game, acting as a jumping-off point to Undercity West and (less directly) Limestone Quarry and Temple of Kiltia, before you finally tackle the Cathedral.";
  room 'Rue Lejour' {
    w 'Tears from Empty Sockets'; dx=1.5; dy=10; -- to Undercity West
    n 'Kesch Bridge';
    e 'From Squire to Knight'; -- to City Walls North
    save_point = true;
  };
  room 'Kesch Bridge' {
    s 'Rue Lejour';
    e 'From Boy to Hero'; -- to City Walls North
    w 'Rue Crimnade';
    save_point = true;
    enemy 'Crimson Blade';
  };
  room 'Rue Crimnade' {
    e 'Kesch Bridge';
    w 'Workshop \'Junction Point\'' 'Cattleya Sigil';
    n 'Rue Fisserano';
    enemy 'Crimson Blade';
  };
  room 'Workshop \'Junction Point\'' {
    e 'Rue Crimnade';
    workshop = { 'W', 'L', 'B', 'I', 'H' };
    save_point = true;
    container = true;
  };
  room 'Rue Fisserano' {
    s 'Rue Crimnade';
    nw 'Shasras Hill Park';
    n 'Workshop \'Metal Works\'';
    trap 'Heal Panel';
    enemy 'Crimson Blade';
  };
  room 'Workshop \'Metal Works\'' {
    s 'Rue Fisserano';
    workshop = { 'H', 'S' };
    save_point = true;
    container = true;
  };
  room 'Shasras Hill Park' {
    se 'Rue Fisserano';
    w 'Hall to a New World' 'Bronze Key'; -- to Undercity East
    enemy 'Crimson Blade';
  };
  -- Path to Great Cathedral.
  room 'The House Gilgitte' {
    se 'Rue Crimnade'; -- latch
    w 'Gharmes Walk';
    chest {
      'Ribsplitter:Khukuri.H/Power Palm', 'Dragonhead',
      'Faerie Wing x5', 'Audentia'
    };
  };
  room 'Gharmes Walk' {
    e 'The House Gilgitte';
    s 'Plateia Lumitar';
    dummy 'Evil' { after = 'Dark Abhors Light' };
    chest {
      locked = true;
      'Klondike:Falchion.S/Power Palm', 'Round Shield.S',
      'Angel Pearl', 'Sorcerer\'s Reagent'
    };
  };
  room 'Plateia Lumitar' {
    n 'Gharmes Walk';
    s 'Exit to City Centre'; -- to Temple of Kiltia
    w 'Into Holy Battle'; -- to Great Cathedral L1
    trap 'Cure Panel';
    save_point = true;
  };
}

region "Town Centre East" {
  "The final hub area of the game, acting as a jumping-off point to Undercity West and (less directly) Limestone Quarry and Temple of Kiltia, before you finally tackle the Cathedral.";
  room 'Rue Lejour' {
    w 'Tears from Empty Sockets'; dx=1.5; dy=10; -- to Undercity West
    n 'Kesch Bridge';
    e 'From Squire to Knight'; -- to City Walls North
  };
  room 'Kesch Bridge' {
    s 'Rue Lejour';
    e 'From Boy to Hero'; -- to City Walls North
    w 'Rue Crimnade';
  };
  room 'Rue Crimnade' {
    e 'Kesch Bridge';
    w 'Workshop \'Junction Point\'';
    n 'Rue Fisserano';
  };
  room 'Workshop \'Junction Point\'' {
    e 'Rue Crimnade';
  };
  room 'Rue Fisserano' {
    s 'Rue Crimnade';
    nw 'Shasras Hill Park';
    n 'Workshop \'Metal Works\'';
  };
  room 'Workshop \'Metal Works\'' {
    s 'Rue Fisserano';
  };
  room 'Shasras Hill Park' {
    se 'Rue Fisserano';
    w 'Hall to a New World';
  };
  -- Path to Great Cathedral.
  room 'The House Gilgitte' {
    se 'Rue Crimnade'; -- latch
    w 'Gharmes Walk';
  };
  room 'Gharmes Walk' {
    e 'The House Gilgitte';
    s 'Plateia Lumitar';
  };
  room 'Plateia Lumitar' {
    n 'Gharmes Walk';
    s 'Exit to City Centre'; -- to Temple of Kiltia
    w 'Into Holy Battle'; -- to Great Cathedral L1
  };
}

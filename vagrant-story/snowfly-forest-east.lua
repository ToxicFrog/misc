region 'Snowfly Forest East' {
  'An NG+ only area containing an optional boss.';
  room 'Steady the Boar-Spears' {
    n 'Train and Grow Strong'; dx=-1.5; dy=-0.5; -- to City Walls East
    s 'The Boar\'s Revenge';
  };
  room 'The Boar\'s Revenge' {
    n 'Steady the Boar-Spears';
    s 'Nature\'s Womb';
  };
  room 'Nature\'s Womb' {
    n 'The Boar\'s Revenge';
    enemy 'Damascus Crab' {
      miniboss = true;
      'Platinum Key', 'Cure Tonic x3'
    };
  };
}

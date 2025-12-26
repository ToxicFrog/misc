region 'Temple of Kiltia' {
  room 'The Dark Coast' {
    s 'Tunnel of the Heartless'; dx=-2; dy=-1; -- to Limestone Quarry
    n 'Hall of Prayer';
    save_point = true;
    container = true;
    trap 'Trap Clear';
    trap 'Heal Panel';
  };
  room 'Hall of Prayer' {
    s 'The Dark Coast';
    e 'Those who Drink the Dark';
    w 'The Resentful Ones';
    enemy 'Last Crusader' {
      miniboss = true;
      'Agrias\'s Balm', 'Grimoire Purifier', 'Alchemist\'s Reagent x3'
    };
  };
  room 'Those who Drink the Dark' {
    w 'Hall of Prayer';
    n 'The Chapel of Meschaunce';
    e 'Ants Prepare for Winter' 'Silver Key'; -- to Limestone Quarry
    puzzle = true;
  };
  room 'The Chapel of Meschaunce' {
    s 'Those who Drink the Dark';
    enemy 'Minotaur Lord' {
      miniboss = true;
      'Titan\'s Ring', 'Elixir of Queens', 'Alchemist\'s Reagent x3'
    };
  };
  room 'The Resentful Ones' {
    e 'Hall of Prayer';
    ne 'Those who Fear the Light' 'Silver Key';
    puzzle = true;
  };
  room 'Those who Fear the Light' {
    sw 'The Resentful Ones';
    n 'Chamber of Reason';
    enemy 'Gremlin';
    enemy 'Air Elemental';
  };
  room 'Chamber of Reason' {
    s 'Those who Fear the Light';
    n 'Exit to City Center';
    enemy 'Kali' { boss = true; };
  };
  room 'Exit to City Center' {
    s 'Chamber of Reason';
    n 'Plateia Lumitar'; -- to City Centre East
  };
}

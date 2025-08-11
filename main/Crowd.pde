class Crowd {
  ArrayList<Enemy> enemiesList = new ArrayList<Enemy>();
  int quantity, lastQuantity;

  Crowd(int qtde, Entity player) {
    this.quantity = qtde;
    this.lastQuantity = this.quantity;
    this.create(player);
  }

  void create(Entity player) {
    this.lastQuantity = this.quantity;
    
    quantity = floor(lastQuantity*random(1, 1.51));
    
    println("enemies created: " + this.quantity);
    
    int[] value = {1, -1};
    for (int i = 0; i < quantity; i++) {
      int signalX = value[int(random(-1, 2))];
      int signalY = value[int(random(-1, 2))];
      PVector pv = new PVector(player.positionVector.x + (signalX * random(500, width + 100)), player.positionVector.y + (signalY * random(500, width + 100)));
      this.enemiesList.add(new Enemy(pv, 0, 0, 30, 30, 100)); //PVector pv, int vx, int vy, int hbw, int hbh, float hp
    }
  }

  void update(Player player) {
    for (int i = 0; i < enemiesList.size(); i++) {
      Enemy enemy = enemiesList.get(i);

      Entity collisionEnemy = enemy;
      if (enemiesList.size() > 1) {
        collisionEnemy = enemiesList.get((i + 1) % enemiesList.size());
      }

      enemy.move(player, enemiesList);

      if (player.attacksList.size() > 0) {
        for(Attack a : player.attacksList) {
          enemy.checkAttack(a);
        }  
      }
      if (!enemy.isAlive()) {
        this.enemiesList.remove(enemy);
        player.experience += 10;
      }
    }
  }
}

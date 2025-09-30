class Crowd {
  ArrayList<Enemy> enemiesList = new ArrayList<Enemy>();
  int quantity, lastQuantity, firstQuantity;

  Crowd(Entity player) {
    this.quantity = player.level*5;
    this.lastQuantity = this.quantity;
    this.firstQuantity = quantity;

    this.create(player);
  }

  void create(Entity player) {
    this.lastQuantity = this.quantity;

    quantity = floor(lastQuantity*random(1, 2.5));

    println("enemies created: " + this.quantity);

    int[] value = {1, -1};
    for (int i = 0; i < quantity; i++) {
      float randomLifeValue = random(8, 20);

      int signalX = value[int(random(-1, 2))];
      int signalY = value[int(random(-1, 2))];
      PVector pv = new PVector(player.positionVector.x + (signalX * random(500, width + 100)), player.positionVector.y + (signalY * random(500, width + 100)));
      this.enemiesList.add(new Enemy(pv, 0, 0, 32, 32, 2)); //PVector pv, int vx, int vy, int hbw, int hbh, float hp
    }

    for (int x = 0; x < int(random(1, quantity*0.3)); x++) {
      Enemy enemy = enemiesList.get(x);
      enemy.playSound(player);
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
        for (Attack a : player.attacksList) {
          enemy.checkAttack(a);
        }
      }
      
      if(!enemy.playedSound && int(random(1, 3000)) == 10) {
        enemy.playSound(player);
      }
      
      if (!enemy.isAlive()) {
        if (int(random(1, 20)) == 4) {
          chickenDieSound.trigger();
        }
        this.enemiesList.remove(enemy);
        player.experience += 10;
      }
    }
  }

  void reset() {
    enemiesList.clear();
    this.quantity = this.firstQuantity;
    this.lastQuantity = this.firstQuantity;
  }
}

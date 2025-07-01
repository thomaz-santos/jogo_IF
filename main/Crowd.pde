class Crowd {
  ArrayList<Enemy> enemiesList = new ArrayList<Enemy>();
  int quantity;
  
  Crowd(int qtde) {
    this.quantity = qtde;
    
    this.create(this.quantity);
  }
  
  void create(int qtde) {
    for(int i = 0;i < qtde; i++) {
      PVector pv = new PVector((int) random(0, 800), (int) random(0, 600));
      //int v = (int) random(1, 4);
      this.enemiesList.add(new Enemy(pv, 0, 0, 30, 30, 100)); //PVector pv, int vx, int vy, int hbw, int hbh, float hp
    }
  }
  
  void update(Player player) {
    for(int i = 0;i < enemiesList.size();i++) {
      Enemy enemy = enemiesList.get(i);
      
      
      enemy.move(player, enemy);
      if(player.attacksList.size() > 0) {
        enemy.checkAttack(player.attacksList.get(0));
      }
      
      if(!enemy.isAlive()) {
        this.enemiesList.remove(enemy);
      }
    }
  }
}

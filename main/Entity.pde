class Entity {
  PVector positionVector;
  int hitboxWidth;
  int hitboxHeight;
  float velocityX;
  float velocityY;
  boolean collision, hittable;
  int hittableCooldown;
  int points;
  float hp, maxHp;
  int lastHit;

  //ArrayList<DamageParticle> damageParticlesList = new ArrayList<DamageParticle>();

  public Entity (PVector pv, float vx, float vy, int hbw, int hbh) {
    this.positionVector = pv;
    this.hitboxWidth = hbw;
    this.hitboxHeight = hbh;
    this.velocityX = vx;
    this.velocityY = vy;

    points = 0;

    maxHp = 100;
    hp = maxHp;
    hittable = true;
    hittableCooldown = 1500;
  }

  void move(boolean moveUp, boolean moveDown, boolean moveRight, boolean moveLeft, ArrayList<Enemy> enemiesCrowd) {
    float nextX = this.positionVector.x;
    float nextY = this.positionVector.y;

    // Calcula o próximo X
    if (moveLeft) {
      nextX -= this.velocityX;
    } else if (moveRight) {
      nextX += this.velocityX;
    }

    if (millis() > lastHit + hittableCooldown) {
      hittable = true;
    }

    // Verifica colisão em X com base no Y atual
    for (Enemy target : enemiesCrowd) {
      if (!checkCollisionX(target, nextX, this.positionVector.y)) {
        this.positionVector.x = nextX;
      } else {
        if (this.hp > 0 && hittable) {
          this.hp -= 25;
          println("hit");
          hittable = false;
          lastHit = millis();
          delay(70);
          //damageParticlesList.add(new DamageParticle(this.positionVector, 1, 2.5, -0.3, 2.0, 800, 5));
        }
      }
    }


    // Calcula o próximo Y
    if (moveUp) {
      nextY -= this.velocityY;
    } else if (moveDown) {
      nextY += this.velocityY;
    }

    // Verifica colisão em Y com base no X atualizado
    for (Enemy target : enemiesCrowd) {
      if (!checkCollisionY(target, this.positionVector.x, nextY)) {
        this.positionVector.y = nextY;
      } else {
        if (this.hp > 0 && hittable) {
          this.hp -= 25;
          println("hit");
          hittable = false;
          lastHit = millis();
          delay(70);
          //damageParticlesList.add(new DamageParticle(this.positionVector, 1, 2.5, -0.3, 2.0, 800, 5)); PVector pv, float vx, float vy, float a, float ma, int lf, int dmg
        }
      }
    }

    this.desenhar();

    //for (DamageParticle p : damageParticlesList) {
    //  p.update();
    //}
  }

  boolean isAlive() {
    if (this.hp > 0) {
      return true;
    }

    return false;
  }


  boolean checkCollision(Entity target) {
    float Ax = this.positionVector.x;
    float Bx = this.positionVector.x + this.hitboxWidth;
    float Cx = target.positionVector.x;
    float Dx = target.positionVector.x  + target.hitboxWidth;

    float Ay = this.positionVector.y;
    float By = this.positionVector.y + this.hitboxHeight;
    float Cy = target.positionVector.y;
    float Dy = target.positionVector.y  + target.hitboxHeight;

    return ((Ax < Dx && Cx < Bx) && (Ay < Dy && Cy < By));
  }

  boolean checkCollisionX(Entity target, float nextX, float currentY) {
    return (
      nextX < target.positionVector.x + target.hitboxWidth &&
      nextX + this.hitboxWidth > target.positionVector.x &&
      currentY < target.positionVector.y + target.hitboxHeight &&
      currentY + this.hitboxHeight > target.positionVector.y
      );
  }

  boolean checkCollisionY(Entity target, float currentX, float nextY) {
    return (
      currentX < target.positionVector.x + target.hitboxWidth &&
      currentX + this.hitboxWidth > target.positionVector.x &&
      nextY < target.positionVector.y + target.hitboxHeight &&
      nextY + this.hitboxHeight > target.positionVector.y
      );
  }

  void desenhar() {
    //Pontos do jogador
    fill(58, 207, 117);
    textAlign(LEFT);
    text("Pontos: " + this.points, width*0.001, height*0.04);

    //Hitbox do jogador
    if (hittable) {
      fill(7, 138, 65, 255);
      rect(this.positionVector.x, this.positionVector.y, this.hitboxWidth, this.hitboxHeight);
    } else {
      fill(7, 138, 65, 120);
      rect(this.positionVector.x, this.positionVector.y, this.hitboxWidth, this.hitboxHeight);
    }

    //Barra de vida do jogador
    float currentHp = map(this.hp, 0, this.maxHp, 0, 200);

    fill(186, 7, 7);
    rect(10, 60, 200, 20);

    fill(58, 207, 117);
    rect(10, 60, currentHp, 20);
  }
}
class Player extends Entity {
  ArrayList<Attack> attacksList = new ArrayList<Attack>();
  boolean attackAvailable = true;
  boolean bulletAttackAvailable = true;
  ArrayList<Dash> dashList = new ArrayList<Dash>();
  boolean dashAvailable = true;

  float baseVelocityX;
  float baseVelocityY;

  public Player(PVector pv, float vx, float vy, int hbw, int hbh) {
    super(pv, vx, vy, hbw, hbh);
    this.baseVelocityX = vx;
    this.baseVelocityY = vy;
  }

  void attack() {
    if (this.attackAvailable) {
      this.attackAvailable = false;

      PVector pv = new PVector(this.positionVector.x + this.hitboxWidth, this.positionVector.y);

      attacksList.add(new Attack(pv, 0, 0, 50, this.hitboxHeight, 500)); //PVector positionVector, int velocityX, int velocityY, int hitboxWidth, int hitboxHeight
    }
  }

  void bulletAttack() {
    if (this.bulletAttackAvailable) {
      this.bulletAttackAvailable = false;

      PVector pv;
      if (mouseX < this.positionVector.x) {
        pv = new PVector(this.positionVector.x, this.positionVector.y);
      } else {
        pv = new PVector(this.positionVector.x + this.hitboxWidth, this.positionVector.y);
      }

      attacksList.add(new BulletAttack(pv, 5, 0, 15, 8, 1500)); //PVector positionVector, int velocityX, int velocityY, int hitboxWidth, int hitboxHeight
    }
  }

  void updateAttacks() {
    for (int i = 0; i < attacksList.size(); i++) {
      Attack attack = attacksList.get(i);

      if (!attack.update(this.positionVector, this.hitboxWidth)) {
        if (attack.getClass() == Attack.class) {
          this.attackAvailable = true;
        } else {
          this.bulletAttackAvailable = true;
        }
        this.attacksList.remove(i);

        //this.velocityX += 3;
        //this.velocityY += 3;
      }
    }
  }

  void dash(boolean moveUp, boolean moveDown, boolean moveRight, boolean moveLeft) {
    if (this.dashAvailable) {
      int dashSpeed = 30;

      int vx, vy;
      if (moveUp) {
        vy = dashSpeed*(-1);
      } else {
        vy = dashSpeed;
      }

      if (moveLeft) {
        vx = dashSpeed*(-1);
      } else {
        vx = dashSpeed;
      }

      this.dashList.add(new Dash(vx, vy, 50));
      this.dashAvailable = false;//int vx, int vy, int duration
    }
  }
  
  void updateDash() {
    
    if(!this.dashList.isEmpty()) {
      Dash dash = dashList.get(0);
      
      if(dash.isActive()) {
        this.velocityX = dash.velocityX;
        this.velocityY = dash.velocityY;
        return;
      }
      
      this.velocityX = this.baseVelocityX;
      this.velocityY = this.baseVelocityY;
      dashList.clear();
      this.dashAvailable = true;
      return;
    }
  }

  void reset() {
    this.hp = this.maxHp;
    this.positionVector.x = width/2;
    this.positionVector.y = height/2;
    this.attacksList.clear();
    this.points = 0;
  }
}

class Enemy extends Entity {
  float hp, maxHp, acceleration;

  public Enemy(PVector pv, float vx, float vy, int hbw, int hbh, float hp) {
    super(pv, vx, vy, hbw, hbh);
    this.hp = hp;
    this.maxHp = hp;
    this.acceleration = 0.6;
  }

  void move(Entity target, ArrayList<Enemy> allEnemies) {
    float nextX = this.positionVector.x;
    float nextY = this.positionVector.y;

    // Aceleração controlada
    if (this.velocityX + this.acceleration >= 1.5) {
      this.velocityX = 1.5;
    } else {
      this.velocityX += this.acceleration;
    }

    if (this.velocityY + this.acceleration >= 1.5) {
      this.velocityY = 1.5;
    } else {
      this.velocityY += this.acceleration;
    }

    // Projeção de posição X
    if (target.positionVector.x > this.positionVector.x) {
      nextX += this.velocityX;
    } else if (target.positionVector.x < this.positionVector.x) {
      nextX -= this.velocityX;
    }

    boolean collidesWithEnemyX = false;
    for (Enemy other : allEnemies) {
      if (other != this) {
        if (checkCollisionX(other, nextX, this.positionVector.y)) {
          collidesWithEnemyX = true;

          // Se já está colidindo no X, empurra levemente:
          if (this.positionVector.x < other.positionVector.x) {
            this.positionVector.x -= 1;
          } else {
            this.positionVector.x += 1;
          }
        }
      }
    }

    if (!checkCollisionX(target, nextX, this.positionVector.y) && !collidesWithEnemyX) {
      this.positionVector.x = nextX;
    } else if (checkCollisionX(target, nextX, this.positionVector.y)) {
      this.velocityX = -7;
      this.positionVector.x = nextX;
    }

    // Projeção de posição Y
    if (target.positionVector.y > this.positionVector.y) {
      nextY += this.velocityY;
    } else if (target.positionVector.y < this.positionVector.y) {
      nextY -= this.velocityY;
    }

    boolean collidesWithEnemyY = false;
    for (Enemy other : allEnemies) {
      if (other != this) {
        if (checkCollisionY(other, this.positionVector.x, nextY)) {
          collidesWithEnemyY = true;

          // Se já está colidindo no Y, empurra levemente:
          if (this.positionVector.y < other.positionVector.y) {
            this.positionVector.y -= 1;
          } else {
            this.positionVector.y += 1;
          }
        }
      }
    }

    if (!checkCollisionY(target, this.positionVector.x, nextY) && !collidesWithEnemyY) {
      this.positionVector.y = nextY;
    } else if (checkCollisionY(target, this.positionVector.x, nextY)) {
      this.velocityY = -7;
      this.positionVector.y = nextY;
    }

    this.desenhar();
  }



  void checkAttack(Attack attack) {
    float nextX = this.positionVector.x;
    float nextY = this.positionVector.y;

    // Movimento em X
    if (attack.positionVector.x > this.positionVector.x) {
      nextX += this.velocityX;
    } else if (attack.positionVector.x < this.positionVector.x) {
      nextX -= this.velocityX;
    }

    if (checkCollisionX(attack, nextX)) {
      this.velocityX = -7;
      this.positionVector.x = nextX;
      this.hp -= 10;
    }

    // Movimento em Y
    if (attack.positionVector.y > this.positionVector.y) {
      nextY += this.velocityY;
    } else if (attack.positionVector.y < this.positionVector.y) {
      nextY -= this.velocityY;
    }

    if (checkCollisionY(attack, nextY)) {
      this.velocityY = -7;
      this.positionVector.y = nextY;
      this.hp -= 10;
    }
  }

  boolean checkCollisionX(Entity target, float nextX) {
    return (
      nextX < target.positionVector.x + target.hitboxWidth &&
      nextX + this.hitboxWidth > target.positionVector.x &&
      this.positionVector.y < target.positionVector.y + target.hitboxHeight &&
      this.positionVector.y + this.hitboxHeight > target.positionVector.y
      );
  }

  boolean checkCollisionX(Attack target, float nextX) {
    return (
      nextX < target.positionVector.x + target.hitboxWidth &&
      nextX + this.hitboxWidth > target.positionVector.x &&
      this.positionVector.y < target.positionVector.y + target.hitboxHeight &&
      this.positionVector.y + this.hitboxHeight > target.positionVector.y
      );
  }

  boolean checkCollisionY(Entity target, float nextY) {
    return (
      this.positionVector.x < target.positionVector.x + target.hitboxWidth &&
      this.positionVector.x + this.hitboxWidth > target.positionVector.x &&
      nextY < target.positionVector.y + target.hitboxHeight &&
      nextY + this.hitboxHeight > target.positionVector.y
      );
  }

  boolean checkCollisionY(Attack target, float nextY) {
    return (
      this.positionVector.x < target.positionVector.x + target.hitboxWidth &&
      this.positionVector.x + this.hitboxWidth > target.positionVector.x &&
      nextY < target.positionVector.y + target.hitboxHeight &&
      nextY + this.hitboxHeight > target.positionVector.y
      );
  }

  boolean isAlive() {
    if (this.hp <= 0) {
      return false;
    }
    return true;
  }


  void desenhar() {
    float currentHp = map(this.hp, 0, this.maxHp, 0, this.hitboxWidth);

    fill(200, 110, 197);
    rect(this.positionVector.x, this.positionVector.y, this.hitboxWidth, this.hitboxHeight);

    fill(240, 0, 0);
    rect(this.positionVector.x, this.positionVector.y + (this.hitboxHeight * 1.1), this.hitboxWidth, 5);

    fill(0, 240, 0);
    rect(this.positionVector.x, this.positionVector.y + (this.hitboxHeight * 1.1), currentHp, 5);
  }
}

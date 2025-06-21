class Entity {
  PVector positionVector;
  int hitboxWidth;
  int hitboxHeight;
  int velocityX;
  int velocityY;
  boolean collision;

  public Entity (PVector pv, int vx, int vy, int hbw, int hbh) {
    this.positionVector = pv;
    this.hitboxWidth = hbw;
    this.hitboxHeight = hbh;
    this.velocityX = vx;
    this.velocityY = vy;
  }

  void move(boolean moveUp, boolean moveDown, boolean moveRight, boolean moveLeft, Entity target) {
    float nextX = this.positionVector.x;
    float nextY = this.positionVector.y;

    // Calcula o próximo X
    if (moveLeft) {
      nextX -= this.velocityX;
    } else if (moveRight) {
      nextX += this.velocityX;
    }

    // Verifica colisão em X com base no Y atual
    if (!checkCollisionX(target, nextX, this.positionVector.y)) {
      this.positionVector.x = nextX;
    }

    // Calcula o próximo Y
    if (moveUp) {
      nextY -= this.velocityY;
    } else if (moveDown) {
      nextY += this.velocityY;
    }

    // Verifica colisão em Y com base no X atualizado
    if (!checkCollisionY(target, this.positionVector.x, nextY)) {
      this.positionVector.y = nextY;
    }

    this.desenhar();
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
    fill(10, 210, 100);
    rect(this.positionVector.x, this.positionVector.y, this.hitboxWidth, this.hitboxHeight);
  }
}
class Player extends Entity {
  ArrayList<Attack> attacksList = new ArrayList<Attack>();
  boolean attackAvailable = true;


  public Player(PVector pv, int vx, int vy, int hbw, int hbh) {
    super(pv, vx, vy, hbw, hbh);
  }

  void attack(char side) {
    if (this.attackAvailable) {
      this.attackAvailable = false;
      
      this.velocityX -= 3;
      this.velocityY -= 3;
      
      PVector pv = new PVector(this.positionVector.x + this.hitboxWidth, this.positionVector.y);
      attacksList.add(new Attack(pv, 0, 0, 50, this.hitboxHeight, side));
    }
    
    
  }

  void updateAttacks() {
    for (int i = 0; i < attacksList.size(); i++) {
      Attack attack = attacksList.get(i);

      if (!attack.update(this.positionVector, this.hitboxWidth)) {
        this.attackAvailable = true;
        this.attacksList.remove(i);
        
        this.velocityX += 3;
        this.velocityY += 3;
      }
    }
  }
}

class Enemy extends Entity {
  float hp, maxHp;
  
  public Enemy(PVector pv, int vx, int vy, int hbw, int hbh, float hp) {
    super(pv, vx, vy, hbw, hbh);
    this.hp = hp;
    this.maxHp = hp;
  }

  void move(Entity target) {
    float nextX = this.positionVector.x;
    float nextY = this.positionVector.y;

    // Movimento em X
    if (target.positionVector.x > this.positionVector.x) {
      nextX += this.velocityX;
    } else if (target.positionVector.x < this.positionVector.x) {
      nextX -= this.velocityX;
    }

    if (!checkCollisionX(target, nextX)) {
      this.positionVector.x = nextX;
    }

    // Movimento em Y
    if (target.positionVector.y > this.positionVector.y) {
      nextY += this.velocityY;
    } else if (target.positionVector.y < this.positionVector.y) {
      nextY -= this.velocityY;
    }

    if (!checkCollisionY(target, nextY)) {
      this.positionVector.y = nextY;
    }

    this.desenhar();
  }

  boolean checkCollisionX(Entity target, float nextX) {
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

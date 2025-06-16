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

  if (!checkCollisionX(target, nextX)) {
    this.positionVector.x = nextX;
  }

  // Calcula o próximo Y
  if (moveUp) {
    nextY -= this.velocityY;
  } else if (moveDown) {
    nextY += this.velocityY;
  }

  if (!checkCollisionY(target, nextY)) {
    this.positionVector.y = nextY;
  }

  this.desenhar();
}
  
  void move(boolean moveUp, boolean moveDown, boolean moveRight, boolean moveLeft) {
    
    if(moveUp) {
      this.positionVector.y -= this.velocityY;
    }
    if(moveLeft) {
      this.positionVector.x -= this.velocityX;
    }
    if(moveDown) {
      this.positionVector.y += this.velocityY;
    }
    if(moveRight) {
      this.positionVector.x += this.velocityX;
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
    fill(10, 210, 100);
    rect(this.positionVector.x, this.positionVector.y, this.hitboxWidth, this.hitboxHeight);
  }
}
class Player extends Entity {
  
  public Player(PVector pv, int vx, int vy, int hbw, int hbh) {
    super(pv, vx, vy, hbw, hbh);
  }
}

class Enemy extends Entity {
  
  public Enemy(PVector pv, int vx, int vy, int hbw, int hbh) {
    super(pv, vx, vy, hbw, hbh);
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
    fill(100, 210, 10);
    rect(this.positionVector.x, this.positionVector.y, this.hitboxWidth, this.hitboxHeight);
  }
}

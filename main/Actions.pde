class Attack {
  int velocityX, velocityY;
  PVector positionVector;
  int hitboxWidth, hitboxHeight;
  Timer t;
  boolean active = false;

  public Attack(PVector positionVector, int velocityX, int velocityY, int hitboxWidth, int hitboxHeight, int duration) {
    this.positionVector = positionVector.copy();
    this.velocityX = velocityX;
    this.velocityY = velocityY;
    this.hitboxWidth = hitboxWidth;
    this.hitboxHeight = hitboxHeight;

    this.t = new Timer(duration);
    this.active = true;
  }

  boolean update(PVector targetVector, int targetWidth) {
    if (t.disparou()) {
      this.active = false;
      return this.active;
    }

    if (mouseX <= targetVector.x) {
      this.positionVector.x = targetVector.x - targetWidth;
      this.positionVector.y = targetVector.y;
    } else {
      this.positionVector.x = targetVector.x + targetWidth;
      this.positionVector.y = targetVector.y;
    }

    this.desenhar();
    return this.active;
  }

  void desenhar() {
    noFill();
    stroke(255, 0, 0);
    rect(this.positionVector.x, this.positionVector.y, this.hitboxWidth, this.hitboxHeight);
    stroke(0);
  }
}

class BulletAttack extends Attack {
  PVector mousePosition;
  
  
  public BulletAttack(PVector positionVector, int velocityX, int velocityY, int hitboxWidth, int hitboxHeight, int duration) {
    super(positionVector, velocityX, velocityY, hitboxWidth, hitboxHeight, duration);
    
    if(mouseX < positionVector.x) {
      this.velocityX *= -1;
    }
    this.mousePosition = new PVector(mouseX, mouseY);
  }
  
  boolean update(PVector targetVector, int targetWidth) {
    /*if (!checkCollisionY(target, positionVector.x, nextY) && !collidesWithEnemyY) {
      PVector des = target.positionVector.copy().sub(positionVector).setMag(velocityY);
      positionVector.add(des);
    } else if (checkCollisionY(target, positionVector.x, nextY)) {
      PVector des = target.positionVector.copy().sub(positionVector).setMag(-velocityY);
      positionVector.add(des);
    }*/
    
    if (t.disparou()) {
      this.active = false;
      return this.active;
    }
    
    PVector des = this.mousePosition.copy().sub(this.positionVector).setMag(velocityX);
    this.positionVector.add(des);

    this.desenhar();
    return this.active;
  }
}

class Dash {
  int velocityX, velocityY;
  Timer t;
  boolean active = true;
  
  public Dash(int vx, int vy, int duration) {
    this.velocityX = vx;
    this.velocityY = vy;
    this.t = new Timer(duration);
  }
  
  boolean isActive() {
    if(t.disparou()) {
      this.active = false;
    }
    
    return this.active;
  }
}

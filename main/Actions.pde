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
  
  public BulletAttack(PVector positionVector, int velocityX, int velocityY, int hitboxWidth, int hitboxHeight, int duration) {
    super(positionVector, velocityX, velocityY, hitboxWidth, hitboxHeight, duration);
    
    if(mouseX < positionVector.x) {
      this.velocityX *= -1;
    }
  }
  
  boolean update(PVector targetVector, int targetWidth) {
    if (t.disparou()) {
      this.active = false;
      return this.active;
    }

    this.positionVector.x += this.velocityX;

    this.desenhar();
    return this.active;
  }
}

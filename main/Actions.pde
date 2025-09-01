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

    if (mouseX <= targetVector.x - cameraX) {
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
    rect(this.positionVector.x - cameraX, this.positionVector.y - cameraY, this.hitboxWidth, this.hitboxHeight);
    stroke(0);
  }
}

class BulletAttack extends Attack {
  PVector mousePosition;
  
  
  public BulletAttack(PVector positionVector, int velocityX, int velocityY, int hitboxWidth, int hitboxHeight, int duration) {
    super(positionVector, velocityX, velocityY, hitboxWidth, hitboxHeight, duration);
    
    
    //float targetX, targetY;
    
    //if(positionVector.x < 0) {
    //  targetX = positionVector.x - mouseX;
    //} else {
    //  targetX = positionVector.x + mouseX;
    //}
    
    //if(positionVector.y < 0) {
    //  targetY = positionVector.y - mouseY;
    //} else {
    //  targetY = positionVector.y + mouseY;
    //}
    
    this.mousePosition = new PVector(mouseX, mouseY);
  }
  
  @Override 
  boolean update(PVector targetVector, int targetWidth) {
    
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

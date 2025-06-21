class Attack {
  int velocityX, velocityY;
  PVector positionVector;
  int hitboxWidth, hitboxHeight;
  char side;
  Timer t;
  boolean active = false;

  public Attack(PVector positionVector, int velocityX, int velocityY, int hitboxWidth, int hitboxHeight, char side) {
    this.positionVector = positionVector.copy();
    this.velocityX = velocityX;
    this.velocityY = velocityY;
    this.hitboxWidth = hitboxWidth;
    this.hitboxHeight = hitboxHeight;
    this.side = side;

    this.t = new Timer(400);
    this.active = true;
  }

  boolean update(PVector targetVector, int targetWidth) {
    if (t.disparou()) {
      this.active = false;
      return this.active;
    }

    if (side == 'l') {
      this.positionVector.x = targetVector.x - targetWidth;
      this.positionVector.y = targetVector.y;
    } else {
      this.positionVector.x = targetVector.x + targetWidth;
      this.positionVector.y = targetVector.y;
    }



    //this.positionVector.x += this.velocityX;
    //this.positionVector.y += this.velocityY;

    this.desenhar();
    return this.active;
  }

  void desenhar() {
    fill(200, 0, 100, 150);
    rect(this.positionVector.x, this.positionVector.y, this.hitboxWidth, this.hitboxHeight);
  }
}

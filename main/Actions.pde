class Attack {
  float velocityX, velocityY;
  PVector positionVector;
  int hitboxWidth, hitboxHeight;
  Timer t;
  boolean active = false;
  int damage;

  public Attack(PVector positionVector, float velocityX, float velocityY, int hitboxWidth, int hitboxHeight, int duration, int dmg) {
    this.positionVector = positionVector.copy();
    this.velocityX = velocityX;
    this.velocityY = velocityY;
    this.hitboxWidth = hitboxWidth;
    this.hitboxHeight = hitboxHeight;

    this.damage = dmg;

    this.t = new Timer(duration);
    this.active = true;
  }

  boolean update(PVector targetVector, int targetWidth) {
    if (t.disparou()) {
      this.active = false;
      return this.active;
    }

    if (mouseX <= targetVector.x - cameraX) {
      this.positionVector.x = targetVector.x - this.hitboxWidth;
      this.positionVector.y = targetVector.y;
    } else {
      this.positionVector.x = targetVector.x + targetWidth;
      this.positionVector.y = targetVector.y;
    }

    this.desenhar();
    return this.active;
  }

  void desenhar() {
    //noFill();
    //stroke(255, 0, 0);
    //rect(this.positionVector.x - cameraX, this.positionVector.y - cameraY, this.hitboxWidth, this.hitboxHeight);
    //stroke(0);
  }
}

class BulletAttack extends Attack {
  PVector mousePosition;


  public BulletAttack(PVector positionVector, float velocityX, float velocityY, int hitboxWidth, int hitboxHeight, int duration, int dmg) {
    super(positionVector, velocityX, velocityY, hitboxWidth, hitboxHeight, duration, dmg);


    //this.mousePosition = new PVector(mouseX + cameraX, mouseY + cameraY);
    // alvo em mundo:
    this.mousePosition = new PVector(mouseX + cameraX, mouseY + cameraY); // ou - se seu translate for +

    // calcula ângulo e fixa velocidades:
    float ang = atan2(this.mousePosition.y - this.positionVector.y,
      this.mousePosition.x - this.positionVector.x);

    // usa velocityX como "speed" já passado no construtor (10 no seu add)
    float speed = this.velocityX;
    this.velocityX = cos(ang) * speed;
    this.velocityY = sin(ang) * speed;
  }

  @Override
    boolean update(PVector targetVector, int targetWidth) {

    if (t.disparou()) {
      this.active = false;
      return false;
    }

    this.positionVector.x += this.velocityX;
    this.positionVector.y += this.velocityY;

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
    if (t.disparou()) {
      this.active = false;
    }

    return this.active;
  }
}

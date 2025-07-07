class Particle {
  PVector positionVector;
  float vx, vy;
  float acceleration, maxAcceleration;
  int duration, creationTime;
  
  public Particle(PVector pv, float vx, float vy, float a, float ma, int lf) {
    this.positionVector = pv;
    this.vx = vx;
    this.vy = vy;
    this.acceleration = a;
    this.maxAcceleration = ma;
    this.duration = lf;
    this.creationTime = millis();
  }
  
  void update() {}
}

class DamageParticle extends Particle {
  int damage;
  
  public DamageParticle(PVector pv, float vx, float vy, float a, float ma, int lf, int dmg) {
    super(pv, vx, vy, a, ma, lf);
    this.damage = dmg;
  }
  
  void update() {
    if(this.vx + this.acceleration > abs(this.maxAcceleration)) {
      this.vx = this.maxAcceleration;
    } else {
      this.vx += acceleration;
    }
    
    if(this.vy + this.acceleration > abs(this.maxAcceleration)) {
      this.vy = this.maxAcceleration;
    } else {
      this.vy += acceleration;
    }
    
    float nextX = this.positionVector.x + vx;
    float nextY = this.positionVector.y + vy;
    
    this.positionVector.x = nextX;
    this.positionVector.y = nextY;
    
    this.draw();
  }
  
  void draw() {
    textAlign(CENTER);
    textSize(map(this.damage, 1, 40, 20, 50));
    fill(230, 30, 30);
    text(this.damage, this.positionVector.x, this.positionVector.y);
  }
}

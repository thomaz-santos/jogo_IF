class Entity {
  PVector positionVector;
  int hitboxWidth, hitboxHeight;
  float velocityX, velocityY;
  boolean collision, hittable;
  int hittableCooldown;
  int experience, level;
  float hp, maxHp;
  int lastHit;

  public Entity(PVector pv, float vx, float vy, int hbw, int hbh) {
    this.positionVector = pv;
    this.hitboxWidth = hbw;
    this.hitboxHeight = hbh;
    this.velocityX = vx;
    this.velocityY = vy;

    this.experience = 0;
    this.maxHp = 100;
    this.hp = maxHp;
    this.hittable = true;
    this.hittableCooldown = 1500;
  }

  void move(boolean moveUp, boolean moveDown, boolean moveRight, boolean moveLeft, ArrayList<Enemy> enemiesCrowd) {
    float nextX = positionVector.x;
    float nextY = positionVector.y;

    // Movimento em X
    if (moveLeft) nextX -= velocityX;
    else if (moveRight) nextX += velocityX;

    if (millis() > lastHit + hittableCooldown) hittable = true;

    for (Enemy target : enemiesCrowd) {
      if (!checkCollisionX(target, nextX, positionVector.y)) {
        positionVector.x = nextX;
      } else {
        if (hp > 0 && hittable) {
          hp -= 25;
          println("hit");
          hittable = false;
          lastHit = millis();
          delay(70);
        }
      }
    }

    // Movimento em Y
    if (moveUp) nextY -= velocityY;
    else if (moveDown) nextY += velocityY;

    for (Enemy target : enemiesCrowd) {
      if (!checkCollisionY(target, positionVector.x, nextY)) {
        positionVector.y = nextY;
      } else {
        if (hp > 0 && hittable) {
          hp -= 25;
          println("hit");
          hittable = false;
          lastHit = millis();
          delay(70);
        }
      }
    }

    desenhar();
  }

  boolean isAlive() {
    return hp > 0;
  }

  boolean checkCollision(Entity target) {
    float Ax = positionVector.x;
    float Bx = positionVector.x + hitboxWidth;
    float Cx = target.positionVector.x;
    float Dx = target.positionVector.x + target.hitboxWidth;

    float Ay = positionVector.y;
    float By = positionVector.y + hitboxHeight;
    float Cy = target.positionVector.y;
    float Dy = target.positionVector.y + target.hitboxHeight;

    return ((Ax < Dx && Cx < Bx) && (Ay < Dy && Cy < By));
  }

  boolean checkCollisionX(Entity target, float nextX, float currentY) {
    return (
      nextX < target.positionVector.x + target.hitboxWidth &&
      nextX + hitboxWidth > target.positionVector.x &&
      currentY < target.positionVector.y + target.hitboxHeight &&
      currentY + hitboxHeight > target.positionVector.y
      );
  }

  boolean checkCollisionY(Entity target, float currentX, float nextY) {
    return (
      currentX < target.positionVector.x + target.hitboxWidth &&
      currentX + hitboxWidth > target.positionVector.x &&
      nextY < target.positionVector.y + target.hitboxHeight &&
      nextY + hitboxHeight > target.positionVector.y
      );
  }

  void desenhar() {
    // Pontos do jogador
    fill(58, 207, 117);
    textAlign(LEFT);
    text("Pontos: " + experience, width * 0.001, height * 0.04);

    // Hitbox do jogador
    if (hittable) fill(7, 138, 65, 255);
    else fill(7, 138, 65, 120);
    rect(positionVector.x, positionVector.y, hitboxWidth, hitboxHeight);

    // Barra de vida do jogador
    float currentHp = map(hp, 0, maxHp, 0, 200);
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

  ArrayList<Dash> dashList = new ArrayList<Dash>(); // mantido (mesmo que não usado)
  boolean dashAvailable = true;

  float baseVelocity;
  float acceleration = 2.2;
  float maxVelocity = 7;
  float friction = 0.7;

  int dashTimer = 0;          // frames restantes do dash
  int dashDuration = 16;      // duração do dash em frames
  int dashCooldownTimer = 0;  // contador de cooldown em frames
  int dashCooldown = 60;      // frames até poder dashar novamente
  boolean dashing = false;    // indicador que estamos em dash
  float dashVx = 0;
  float dashVy = 0;
  int dashSpeed = 15;

  public Player(PVector pv, float vx, float vy, int hbw, int hbh) {
    super(pv, vx, vy, hbw, hbh);
    this.baseVelocity = vx; // corrigido para manter apenas vx (o vy original sobrescrevia)
  }

  @Override
    void move(boolean moveUp, boolean moveDown, boolean moveRight, boolean moveLeft, ArrayList<Enemy> enemiesCrowd) {
    this.dashCooldown = floor(frameRate * 1.5);

    // 1) cooldown tick (somente aqui, já que move() é chamado todo frame)
    if (!dashAvailable && !dashing && dashCooldownTimer > 0) {
      dashCooldownTimer--;
    }
    if (!dashAvailable && !dashing && dashCooldownTimer == 0) {
      dashAvailable = true;
    }

    // 2) Se estamos em dash, aplicamos dashVx/dashVy e fim — NÃO executamos o MUV normal
    if (dashing) {
      float nextX = positionVector.x + dashVx;
      float nextY = positionVector.y + dashVy;

      if (millis() > lastHit + hittableCooldown && !dashing) hittable = true;

      // Colisão X usando nextX
      for (Enemy target : enemiesCrowd) {
        if (!checkCollisionX(target, nextX, positionVector.y)) {
          positionVector.x = nextX;
        } else if (hp > 0 && hittable) {
          hp -= 25;
          println("hit");
          hittable = false;
          lastHit = millis();
          delay(70);
        }
      }

      // Colisão Y usando nextY
      for (Enemy target : enemiesCrowd) {
        if (!checkCollisionY(target, positionVector.x, nextY)) {
          positionVector.y = nextY;
        } else if (hp > 0 && hittable) {
          hp -= 25;
          println("hit");
          hittable = false;
          lastHit = millis();
          delay(70);
        }
      }

      // decrementa timer do dash
      dashTimer--;
      if (dashTimer <= 0) {
        dashing = false;
        // zera velocities para o MUV assumir novamente (ajuste se preferir restaurar velocidade anterior)
        velocityX = 0;
        velocityY = 0;
        // inicia cooldown
        dashCooldownTimer = dashCooldown;
        dashAvailable = false;
      }

      desenhar();
      return; // pula MUV normal enquanto dashing
    }

    // 3) MUV normal quando NÃO estiver dashando
    // Atualiza velocidade em X
    if (moveLeft) {
      velocityX = max(velocityX - acceleration, -maxVelocity);
    } else if (moveRight) {
      velocityX = min(velocityX + acceleration, maxVelocity);
    } else {
      if (velocityX > 0) velocityX = max(0, velocityX - friction);
      else if (velocityX < 0) velocityX = min(0, velocityX + friction);
    }

    // Atualiza velocidade em Y
    if (moveUp) {
      velocityY = max(velocityY - acceleration, -maxVelocity);
    } else if (moveDown) {
      velocityY = min(velocityY + acceleration, maxVelocity);
    } else {
      if (velocityY > 0) velocityY = max(0, velocityY - friction);
      else if (velocityY < 0) velocityY = min(0, velocityY + friction);
    }

    float nextX = positionVector.x + velocityX;
    float nextY = positionVector.y + velocityY;

    if (millis() > lastHit + hittableCooldown && !dashing) hittable = true;

    // Colisão em X
    for (Enemy target : enemiesCrowd) {
      if (!checkCollisionX(target, nextX, positionVector.y)) {
        positionVector.x = nextX;
      } else if (hp > 0 && hittable) {
        hp -= 25;
        println("hit");
        hittable = false;
        lastHit = millis();
        delay(70);
      }
    }

    // Colisão em Y
    for (Enemy target : enemiesCrowd) {
      if (!checkCollisionY(target, positionVector.x, nextY)) {
        positionVector.y = nextY;
      } else if (hp > 0 && hittable) {
        hp -= 25;
        println("hit");
        hittable = false;
        lastHit = millis();
        delay(70);
      }
    }

    desenhar();
  }

  void attack() {
    if (attackAvailable) {
      attackAvailable = false;
      PVector pv = new PVector(positionVector.x + hitboxWidth, positionVector.y);
      attacksList.add(new Attack(pv, 0, 0, 50, hitboxHeight, 500));
    }
  }

  void bulletAttack() {
    if (bulletAttackAvailable) {
      bulletAttackAvailable = false;

      PVector pv = (mouseX < positionVector.x)
        ? new PVector(positionVector.x, positionVector.y)
        : new PVector(positionVector.x + hitboxWidth, positionVector.y);

      attacksList.add(new BulletAttack(pv, 5, 0, 15, 8, 1500));
    }
  }

  void updateAttacks() {
    for (int i = 0; i < attacksList.size(); i++) {
      Attack attack = attacksList.get(i);
      if (!attack.update(positionVector, hitboxWidth)) {
        if (attack.getClass() == Attack.class) attackAvailable = true;
        else bulletAttackAvailable = true;
        attacksList.remove(i);
      }
    }
  }


  // dash() agora somente tenta INICIAR o dash (edge start). A atualização do dash acontece em move()
  void dash(boolean moveUp, boolean moveDown, boolean moveRight, boolean moveLeft, boolean dashPressed) {
    if (!dashPressed) return;               // só reagir ao evento de pressionar
    if (!dashAvailable || dashing) return;  // não pode iniciar se em cooldown ou já dashando

    // calcula direção (pode ser diagonal)
    int dirX = 0;
    int dirY = 0;
    if (moveLeft) dirX -= 1;
    if (moveRight) dirX += 1;
    if (moveUp) dirY -= 1;
    if (moveDown) dirY += 1;

    // não inicia dash sem direção
    if (dirX == 0 && dirY == 0) return;

    float mag = sqrt((float)(dirX*dirX + dirY*dirY));
    if (mag == 0) mag = 1;
    dashVx = (dirX / mag) * dashSpeed;
    dashVy = (dirY / mag) * dashSpeed;

    dashTimer = dashDuration;
    dashing = true;
    dashAvailable = false; // cooldown será contado ao final do dash (em move())

    hittable = false; // <<< Fica intangível durante o dash
  }

  void reset() {
    hp = maxHp;
    positionVector.x = width / 2;
    positionVector.y = height / 2;
    attacksList.clear();
    experience = 0;
  }
  
  void manageLevel() {
    
  }
  
  @Override
  void desenhar() {
    // Pontos do jogador
    fill(58, 207, 117);
    textAlign(LEFT);
    text("Pontos: " + experience, width * 0.001, height * 0.04);

    // Hitbox do jogador
    if (hittable) fill(7, 138, 65, 255);
    else fill(7, 138, 65, 120);
    rect(positionVector.x, positionVector.y, hitboxWidth, hitboxHeight);

    // Barra de vida do jogador
    float currentHp = map(hp, 0, maxHp, 0, 200);
    fill(186, 7, 7);
    rect(10, 60, 200, 20);
    fill(58, 207, 117);
    rect(10, 60, currentHp, 20);
    
    //Barra de nível do Jogador
    fill(186, 7, 7);
    rect(width*0.25, 60, width*0.35, 20);
    fill(10, 40, 200);
    rect(width*0.25, 60, width*0.35, 20);
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
    float nextX = positionVector.x;
    float nextY = positionVector.y;

    // Aceleração controlada
    velocityX = min(velocityX + acceleration, 1.5);
    velocityY = min(velocityY + acceleration, 1.5);

    // Movimento em X
    if (target.positionVector.x > positionVector.x) nextX += velocityX;
    else if (target.positionVector.x < positionVector.x) nextX -= velocityX;

    boolean collidesWithEnemyX = false;
    for (Enemy other : allEnemies) {
      if (other != this && checkCollisionX(other, nextX, positionVector.y)) {
        collidesWithEnemyX = true;
        positionVector.x += (positionVector.x < other.positionVector.x) ? -1 : 1;
      }
    }

    if (!checkCollisionX(target, nextX, positionVector.y) && !collidesWithEnemyX) {
      PVector des = target.positionVector.copy().sub(positionVector).setMag(velocityX);
      positionVector.add(des);
    } else if (checkCollisionX(target, nextX, positionVector.y)) {
      PVector des = target.positionVector.copy().sub(positionVector).setMag(-velocityX);
      positionVector.add(des);
    }

    // Movimento em Y
    if (target.positionVector.y > positionVector.y) nextY += velocityY;
    else if (target.positionVector.y < positionVector.y) nextY -= velocityY;

    boolean collidesWithEnemyY = false;
    for (Enemy other : allEnemies) {
      if (other != this && checkCollisionY(other, positionVector.x, nextY)) {
        collidesWithEnemyY = true;
        positionVector.y += (positionVector.y < other.positionVector.y) ? -1 : 1;
      }
    }

    if (!checkCollisionY(target, positionVector.x, nextY) && !collidesWithEnemyY) {
      PVector des = target.positionVector.copy().sub(positionVector).setMag(velocityY);
      positionVector.add(des);
    } else if (checkCollisionY(target, positionVector.x, nextY)) {
      PVector des = target.positionVector.copy().sub(positionVector).setMag(-velocityY);
      positionVector.add(des);
    }

    desenhar();
  }

  void checkAttack(Attack attack) {
    float nextX = positionVector.x;
    float nextY = positionVector.y;

    if (attack.positionVector.x > positionVector.x) nextX += velocityX;
    else if (attack.positionVector.x < positionVector.x) nextX -= velocityX;

    if (checkCollisionX(attack, nextX)) {
      velocityX = -7;
      positionVector.x = nextX;
      hp -= 10;
    }

    if (attack.positionVector.y > positionVector.y) nextY += velocityY;
    else if (attack.positionVector.y < positionVector.y) nextY -= velocityY;

    if (checkCollisionY(attack, nextY)) {
      velocityY = -7;
      positionVector.y = nextY;
      hp -= 10;
    }
  }

  boolean checkCollisionX(Entity target, float nextX) {
    return (
      nextX < target.positionVector.x + target.hitboxWidth &&
      nextX + hitboxWidth > target.positionVector.x &&
      positionVector.y < target.positionVector.y + target.hitboxHeight &&
      positionVector.y + hitboxHeight > target.positionVector.y
      );
  }

  boolean checkCollisionX(Attack target, float nextX) {
    return (
      nextX < target.positionVector.x + target.hitboxWidth &&
      nextX + hitboxWidth > target.positionVector.x &&
      positionVector.y < target.positionVector.y + target.hitboxHeight &&
      positionVector.y + hitboxHeight > target.positionVector.y
      );
  }

  boolean checkCollisionY(Entity target, float nextY) {
    return (
      positionVector.x < target.positionVector.x + target.hitboxWidth &&
      positionVector.x + hitboxWidth > target.positionVector.x &&
      nextY < target.positionVector.y + target.hitboxHeight &&
      nextY + hitboxHeight > target.positionVector.y
      );
  }

  boolean checkCollisionY(Attack target, float nextY) {
    return (
      positionVector.x < target.positionVector.x + target.hitboxWidth &&
      positionVector.x + hitboxWidth > target.positionVector.x &&
      nextY < target.positionVector.y + target.hitboxHeight &&
      nextY + hitboxHeight > target.positionVector.y
      );
  }

  boolean isAlive() {
    return hp > 0;
  }

  void desenhar() {
    float currentHp = map(hp, 0, maxHp, 0, hitboxWidth);
    fill(200, 110, 197);
    rect(positionVector.x, positionVector.y, hitboxWidth, hitboxHeight);

    fill(240, 0, 0);
    rect(positionVector.x, positionVector.y + (hitboxHeight * 1.1), hitboxWidth, 5);

    fill(0, 240, 0);
    rect(positionVector.x, positionVector.y + (hitboxHeight * 1.1), currentHp, 5);
  }
}

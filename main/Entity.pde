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
    this.level = 1;
    this.maxHp = 3;
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

  boolean colidiuCenario(Camada colisao) {
    int xi, xf, yi, yf;

    xi= int(this.positionVector.x)/colisao.tLar;
    xf= int(this.positionVector.x+this.hitboxWidth-1)/colisao.tLar;
    yi= int(this.positionVector.y)/colisao.tAlt;
    yf= int(this.positionVector.y+this.hitboxHeight-1)/colisao.tAlt;

    if (xi<0)xi=0;
    if (xi>colisao.lar-1) xi=colisao.lar-1;
    if (xf<0)xf=0;
    if (xf>colisao.lar-1) xf=colisao.lar-1;

    if (yi<0)yi=0;
    if (yi>colisao.alt-1) yi=colisao.alt-1;
    if (yf<0)yf=0;
    if (yf>colisao.alt-1) yf=colisao.alt-1;

    for (int i=xi; i<=xf; i++) {
      for (int j=yi; j<=yf; j++) {
        if (colisao.get(j, i)!=-1) return true;
      }
    }
    return false;
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
  float acceleration;
  float maxVelocity;
  float friction;

  int dashTimer = 0;          // frames restantes do dash
  int dashDuration = 16;      // duração do dash em frames
  int dashCooldownTimer = 0;  // contador de cooldown em frames
  int dashCooldown = 60;      // frames até poder dashar novamente
  boolean dashing = false;    // indicador que estamos em dash
  float dashVx = 0;
  float dashVy = 0;
  int dashSpeed = 15;

  int attackDamage;

  PImage lifePoint;
  PImage[][] sprites;
  Timer tAni; //timer animação
  int quadro, direcao;
  int mEsq, mCima;

  boolean attacking; // se está no meio de uma animação de ataque
  int atkFrame;          // quadro atual da animação de ataque
  int atkFrames;         // número de quadros da animação (ajuste conforme sprite)
  Timer atkAni;              // timer só para ataque

  public Player(PVector pv, float vx, float vy, int hbw, int hbh, float maxV, float accele, float fric, int atkDmg) {
    super(pv, vx, vy, hbw, hbh);
    this.baseVelocity = vx; // corrigido para manter apenas vx (o vy original sobrescrevia)
    this.maxVelocity = maxV;
    this.acceleration = accele;
    this.friction = fric;
    this.attackDamage = atkDmg;

    this.lifePoint = loadImage("HUD/life-point.png");

    PImage aux;
    aux = loadImage("characters/player/player4.png");
    aux.resize(64*4*2, 64*4*3);
    //aux.resize(larSpr*4*escala,altSpr*4*escala);
    sprites = new PImage[6][4];
    for (int i=0; i<6; i++)
    {
      for (int j=0; j<4; j++)
      {
        sprites[i][j] = aux.get(j*128, i*128, 128, 128);
        //j*larSpr,i*altSpr,larSpr,altSpr
      }
    }
    tAni = new Timer(1000/4);
    this.mEsq =32;
    this.mCima = 32;

    this.atkAni = new Timer(800/4);
    this.attacking = false;
    this.atkFrame = 0;          // quadro atual da animação de ataque
    this.atkFrames = 3;
  }

  @Override
    void move(boolean moveUp, boolean moveDown, boolean moveRight, boolean moveLeft, ArrayList<Enemy> enemiesCrowd) {
    this.dashCooldown = floor(frameRate * 1.5);

    // 1) Cooldown do dash
    if (!dashAvailable && !dashing && dashCooldownTimer > 0) {
      dashCooldownTimer--;
    }
    if (!dashAvailable && !dashing && dashCooldownTimer == 0) {
      dashAvailable = true;
    }

    // =========================
    // 2) SE ESTIVER DASHANDO
    // =========================
    if (dashing) {
      float nextX = positionVector.x + dashVx;
      float nextY = positionVector.y + dashVy;

      if (millis() > lastHit + hittableCooldown && !dashing) hittable = true;

      // ---- Colisão com cenário durante o dash ----
      // Primeiro checa eixo X
      boolean colisaoX = this.colidiuCenarioEmX(colisao, nextX, positionVector.y);
      if (!colisaoX) {
        positionVector.x = nextX;
      } else {
        // Ajusta posição para encostar na parede
        if (dashVx > 0) { // indo para direita
          int tileCol = int((nextX + hitboxWidth) / colisao.tLar);
          positionVector.x = tileCol * colisao.tLar - hitboxWidth;
        } else if (dashVx < 0) { // indo para esquerda
          int tileCol = int(nextX / colisao.tLar);
          positionVector.x = (tileCol + 1) * colisao.tLar;
        }
        dashVx = 0; // cancela movimento horizontal do dash
      }

      // Depois checa eixo Y
      boolean colisaoY = this.colidiuCenarioEmY(colisao, positionVector.x, nextY);
      if (!colisaoY) {
        positionVector.y = nextY;
      } else {
        // Ajusta posição para encostar no tile
        if (dashVy > 0) { // descendo
          int tileRow = int((nextY + hitboxHeight) / colisao.tAlt);
          positionVector.y = tileRow * colisao.tAlt - hitboxHeight;
        } else if (dashVy < 0) { // subindo
          int tileRow = int(nextY / colisao.tAlt);
          positionVector.y = (tileRow + 1) * colisao.tAlt;
        }
        dashVy = 0; // cancela movimento vertical do dash
      }

      // ---- Colisão com inimigos durante dash ----
      for (Enemy target : enemiesCrowd) {
        if (checkCollisionX(target, positionVector.x, positionVector.y) && hp > 0 && hittable) {
          hp -= 1;
          playerHit.trigger();
          hittable = false;
          lastHit = millis();
        }
      }

      // decrementa timer do dash
      dashTimer--;
      if (dashTimer <= 0 || (dashVx == 0 && dashVy == 0)) {
        dashing = false;
        velocityX = 0;
        velocityY = 0;
        dashCooldownTimer = dashCooldown;
        dashAvailable = false;
      }

      desenhar();
      return; // pula MUV normal enquanto estiver em dash
    }

    // =========================
    // 3) MOVIMENTO NORMAL (MUV)
    // =========================

    // --- Atualiza velocidade em X
    if (moveLeft) {
      velocityX = max(velocityX - acceleration, -maxVelocity);
    } else if (moveRight) {
      velocityX = min(velocityX + acceleration, maxVelocity);
    } else {
      if (velocityX > 0) velocityX = max(0, velocityX - friction);
      else if (velocityX < 0) velocityX = min(0, velocityX + friction);
    }

    // --- Atualiza velocidade em Y
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

    // =========================
    // 4) MOVIMENTO E COLISÃO EM X
    // =========================
    boolean colisaoX = this.colidiuCenarioEmX(colisao, nextX, positionVector.y);
    if (!colisaoX) {
      positionVector.x = nextX;
    } else {
      if (velocityX > 0) { // movendo para direita
        int tileCol = int((nextX + hitboxWidth) / colisao.tLar);
        positionVector.x = tileCol * colisao.tLar - hitboxWidth;
      } else if (velocityX < 0) { // movendo para esquerda
        int tileCol = int(nextX / colisao.tLar);
        positionVector.x = (tileCol + 1) * colisao.tLar;
      }
      velocityX = 0;
    }

    // Colisão X com inimigos
    for (Enemy target : enemiesCrowd) {
      if (checkCollisionX(target, positionVector.x, positionVector.y) && hp > 0 && hittable) {
        hp -= 1;
        playerHit.trigger();
        hittable = false;
        lastHit = millis();
      }
    }

    // =========================
    // 5) MOVIMENTO E COLISÃO EM Y
    // =========================
    boolean colisaoY = this.colidiuCenarioEmY(colisao, positionVector.x, nextY);
    if (!colisaoY) {
      positionVector.y = nextY;
    } else {
      if (velocityY > 0) { // descendo
        int tileRow = int((nextY + hitboxHeight) / colisao.tAlt);
        positionVector.y = tileRow * colisao.tAlt - hitboxHeight;
      } else if (velocityY < 0) { // subindo
        int tileRow = int(nextY / colisao.tAlt);
        positionVector.y = (tileRow + 1) * colisao.tAlt;
      }
      velocityY = 0;
    }

    // Colisão Y com inimigos
    for (Enemy target : enemiesCrowd) {
      if (checkCollisionY(target, positionVector.x, positionVector.y) && hp > 0 && hittable) {
        hp -= 1;
        playerHit.trigger();
        hittable = false;
        lastHit = millis();
      }
    }

    // =========================
    // 6) DESENHAR PERSONAGEM
    // =========================
    desenhar();
  }


  boolean colidiuCenarioEmX(Camada colisao, float testX, float currentY) {
    int leftTile = int(testX / colisao.tLar);
    int rightTile = int((testX + hitboxWidth - 1) / colisao.tLar);
    int topTile = int(currentY / colisao.tAlt);
    int bottomTile = int((currentY + hitboxHeight - 1) / colisao.tAlt);

    for (int y = topTile; y <= bottomTile; y++) {
      for (int x = leftTile; x <= rightTile; x++) {
        if (colisao.get(y, x) != -1) return true; // tile sólido
      }
    }
    return false;
  }

  boolean colidiuCenarioEmY(Camada colisao, float currentX, float testY) {
    int leftTile = int(currentX / colisao.tLar);
    int rightTile = int((currentX + hitboxWidth - 1) / colisao.tLar);
    int topTile = int(testY / colisao.tAlt);
    int bottomTile = int((testY + hitboxHeight - 1) / colisao.tAlt);

    for (int y = topTile; y <= bottomTile; y++) {
      for (int x = leftTile; x <= rightTile; x++) {
        if (colisao.get(y, x) != -1) return true; // tile sólido
      }
    }
    return false;
  }




  void attack() {
    if (attackAvailable) {
      attackAvailable = false;
      PVector pv;

      if (mouseX > this.positionVector.x) {
        pv = new PVector(positionVector.x + hitboxWidth, positionVector.y);
      } else {
        pv = new PVector(positionVector.x, positionVector.y);
      }

      attacksList.add(new Attack(pv, 0, 0, 30, hitboxHeight+10, 800, this.attackDamage));
      //PVector positionVector, int velocityX, int velocityY, int hitboxWidth, int hitboxHeight, int duration, int damage
      playerAttackSound.trigger();

      // ativa animação de ataque
      attacking = true;
      atkFrame = 0;
      atkAni.reset();
    }
  }

  void bulletAttack() {
    if (bulletAttackAvailable) {
      bulletAttackAvailable = false;

      PVector pv = (mouseX < positionVector.x)
        ? new PVector(positionVector.x, positionVector.y)
        : new PVector(positionVector.x + hitboxWidth, positionVector.y);


      //PVector positionVector, int velocityX, int velocityY, int hitboxWidth, int hitboxHeight, int duration
      attacksList.add(new BulletAttack(pv, 10, 0, 15, 8, 500, this.attackDamage));
    }
  }

  void updateAttacks() {
    for (int i = 0; i < attacksList.size(); i++) {
      Attack attack = attacksList.get(i);
      if (!attack.update(positionVector, hitboxWidth)) {
        if (attack.getClass() == Attack.class) {
          attackAvailable = true;
        } else bulletAttackAvailable = true;
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
    if (this.experience >= this.level*20) {
      this.level++;
      this.experience = 0;
      //this.attackDamage *= 1.05;

      if (this.hp * 1.1 >= this.maxHp) {
        this.hp = maxHp;
      } else {
        this.hp += this.maxHp*0.2;
      }
    }
  }

  @Override
    void desenhar() {
    // Pontos do jogador
    fill(58, 207, 117);
    textAlign(LEFT);
    text("Pontos: " + experience, 10, height * 0.04);

    // Hitbox do jogador
    //if (hittable) fill(7, 138, 65, 255);
    //else fill(7, 138, 65, 120);
    //rect(positionVector.x - cameraX, positionVector.y - cameraY, hitboxWidth, hitboxHeight);
    //fill(255, 0, 0, 255);
    //noFill();
    //stroke(0, 255, 0);
    //rect(positionVector.x - cameraX, positionVector.y - cameraY, hitboxWidth, hitboxHeight);

    if (tAni.disparou())
    {
      quadro=(quadro+1)%4;
    }

    if (attacking) {
      // avança quadro de ataque
      if (atkAni.disparou()) {
        atkFrame++;
        if (atkFrame >= atkFrames) {
          atkFrame = 0;
          attacking = false; // animação terminou
        }
      }

      if (mouseX < this.positionVector.x  - cameraX)direcao = 3;
      else if (mouseX > this.positionVector.x  - cameraX)direcao = 2;

      // escolhe linha do sprite de ataque
      int linhaAtk;
      if (direcao == 2) linhaAtk = 4; // direita (5ª linha do sprite, index 4)
      else if (direcao == 3) linhaAtk = 5; // esquerda (6ª linha do sprite, index 5)
      else linhaAtk = 4; // fallback: direita por padrão

      image(sprites[linhaAtk][atkFrame], this.positionVector.x-cameraX-mEsq, this.positionVector.y-cameraY-mCima);
    } else {
      if (moveDown)direcao=0;
      else if (moveRight)direcao=2;
      else if (moveUp)direcao=1;
      else if (moveLeft)direcao=3;
      else quadro=0;

      image(sprites[direcao][quadro], this.positionVector.x-cameraX-mEsq, this.positionVector.y-cameraY-mCima);
      stroke(0);
      noFill();
    }

    //Indicador de dash
    //if (dashAvailable) {
    //  rectMode(CENTER);
    //  fill(10, 50, 190);
    //  rect((this.positionVector.x + this.hitboxWidth/2)-cameraX, (this.positionVector.y + this.hitboxHeight/2)-cameraY, this.hitboxWidth*0.4, this.hitboxHeight*0.4);
    //  rectMode(CORNER);
    //}

    for (int i = 0; i<this.hp; i++) {
      image(lifePoint, width*0.03 + i*32, height*0.05);
    }

    ////Nivel do jogador
    //fill(58, 207, 117);
    //textAlign(LEFT);
    //text(level, width*0.95, height * 0.04);

    ////Barra de nível do Jogador
    //this.manageLevel();

    //float currentXp = map(this.experience, 0, level*20, 0, width*0.4);
    //fill(186, 7, 7);
    //rect(width*0.3, 60, width*0.4, 20);
    //fill(10, 40, 200);
    //rect(width*0.3, 60, currentXp, 20);
  }
}


class Enemy extends Entity {
  float hp, maxHp, acceleration;

  PImage[][] sprites;
  Timer tAni; //timer animação
  int quadro, direcao;
  int mEsq, mCima;
  //Timer soundTimer;
  boolean playedSound;

  public Enemy(PVector pv, float vx, float vy, int hbw, int hbh, float hp) {
    super(pv, vx, vy, hbw, hbh);
    this.hp = hp;
    this.maxHp = hp;
    this.acceleration = 0.6;

    this.hittableCooldown = 1000;
    this.hittable = true;
    this.lastHit = 0;

    PImage aux;
    aux = loadImage("characters/chicken/galinha.png");
    aux.resize(32*4*1, 32*4*1);
    //aux.resize(larSpr*4*escala,altSpr*4*escala);
    sprites = new PImage[4][4];
    for (int i=0; i<4; i++)
    {
      for (int j=0; j<4; j++)
      {
        sprites[i][j] = aux.get(j*32, i*32, 32, 32);
        //j*larSpr,i*altSpr,larSpr,altSpr
      }
    }
    tAni = new Timer(1000/4);
    this.mEsq =0;
    this.mCima = 0;
  }

  void playSound(Entity target) {
    if (gameState == 1) {
      playedSound = true;

      chickenSound.setGain(-3);

      chickenSound.trigger();
    }
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

    desenhar(target);
  }

  void checkAttack(Attack attack) {
    float nextX = positionVector.x;
    float nextY = positionVector.y;

    if (millis() > this.lastHit + this.hittableCooldown) {
      hittable = true;
    }


    if (attack.positionVector.x > positionVector.x) nextX += velocityX;
    else if (attack.positionVector.x < positionVector.x) nextX -= velocityX;

    if (checkCollisionX(attack, nextX) && hittable) {
      this.velocityX = -7;
      this.positionVector.x = nextX;
      this.hp -= attack.damage;

      this.hittable = false;
      this.lastHit = millis();

      println(this.toString());
    }

    if (attack.positionVector.y > positionVector.y) nextY += velocityY;
    else if (attack.positionVector.y < positionVector.y) nextY -= velocityY;

    if (checkCollisionY(attack, nextY) && hittable) {
      this.velocityY = -7;
      this.positionVector.y = nextY;
      this.hp -= attack.damage;

      this.hittable = false;
      this.lastHit = millis();

      println(this.toString());
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

  void desenhar(Entity target) {
    //float currentHp = map(hp, 0, maxHp, 0, hitboxWidth);
    //fill(240, 0, 0);
    //rect(positionVector.x - cameraX, positionVector.y + (hitboxHeight * 1.1) - cameraY, hitboxWidth, 5);

    //fill(0, 240, 0);
    //rect(positionVector.x - cameraX, positionVector.y + (hitboxHeight * 1.1) - cameraY, currentHp, 5);


    if (tAni.disparou())
    {
      quadro=(quadro+1)%4;
    }

    if (abs(target.positionVector.x) - abs(this.positionVector.x) > abs(target.positionVector.y) - abs(this.positionVector.y)) {
      if (target.positionVector.x > this.positionVector.x)direcao=2;
      else if (target.positionVector.x < this.positionVector.x)direcao=0;
    } else if (abs(target.positionVector.x) - abs(this.positionVector.x) < abs(target.positionVector.y) - abs(this.positionVector.y)) {
      if (target.positionVector.y > this.positionVector.y)direcao=3;
      else if (target.positionVector.y < this.positionVector.y)direcao=1;
    } else {
      quadro = 0;
    }

    //if (target.positionVector.x > this.positionVector.x)direcao=2;
    //else if (target.positionVector.x < this.positionVector.x)direcao=0;
    //else if (target.positionVector.y > this.positionVector.y)direcao=1;
    //else if (target.positionVector.y < this.positionVector.y)direcao=3;
    //else quadro=0;

    image(sprites[direcao][quadro], this.positionVector.x-cameraX-mEsq, this.positionVector.y-cameraY-mCima);

    //hitbox
    //noFill();
    //stroke(255, 0, 0);
    //rect(positionVector.x - cameraX, positionVector.y - cameraY, hitboxWidth, hitboxHeight);
  }



  @Override
    String toString() {
    return "Vida: " + this.maxHp;
  }
}

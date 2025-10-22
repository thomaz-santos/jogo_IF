import ddf.minim.*;

int gameState = 0;
MenuManager menuManager;

float cameraX, cameraY;

Timer t = new Timer(5000);
//Timer gameTime = new Timer(10000);

float velocidadeMax;
boolean moveUp, moveDown, moveRight, moveLeft, attackPressed, dashPressed, quitGame;
char lastSide;
PVector pv;
Player p;

Crowd crowd;
GameTimer gameTimer;
boolean initialTime  = true;


Camada fundo;
Camada colisao;
Camada frente;
PImage tiles;

Camada fundoTutorial;
Camada colisaoTutorial;
Camada frenteTutorial;
PImage tilesTutorial;

PImage tutorialHUD;

PImage wIcon, aIcon, sIcon, dIcon;

Minim minim;
AudioSample playerAttackSound;
AudioSample chickenSound;
AudioSample buttonClickSound;
AudioSample returnButtonClickSound;
AudioSample chickenDieSound;
AudioSample playerHit;
AudioSample playerDie;
AudioSample playerWin;
ArrayList<AudioSample> globalSamples = new ArrayList<AudioSample>();

AudioPlayer defaultMusic;

PImage cursorDefault;

//Variáveis para o menu de tutorial == Player
PImage[][] sprites;
Timer atkAni;
boolean attacking = false;
int atkFrame = 0;
int atkFrames = 3; // nº de quadros da animação de ataque
int direcao = 2;   // direita como padrão no menu
int mEsq = 32, mCima = 32; // ajuste da posição do sprite

//Variáveis para o menu de tutorial == Galinha
PImage[][] enemySprites;
Timer enemyIdleAni;
int enemyIdleFrame = 0;

Timer clockIdle;
PImage clockSprite;
int currentClockSprite;


PVector returnButtonPV;
Button returnButton;
//PVector pv, float hitboxWidth, float hitboxHeight, String text, String path, int v

void setup() {
  size(900, 700);
  //fullScreen();

  minim = new Minim(this);
  playerAttackSound = minim.loadSample("audio/sfx/playerAttackSound.mp3");
  chickenSound = minim.loadSample("audio/sfx/chickenSound.mp3");
  buttonClickSound = minim.loadSample("audio/sfx/buttonClick.mp3");
  returnButtonClickSound = minim.loadSample("audio/sfx/returnButtonClick.mp3");

  chickenDieSound = minim.loadSample("audio/sfx/chickenDie.mp3");
  chickenDieSound.setGain(-15);

  playerHit = minim.loadSample("audio/sfx/playerHit.mp3");
  playerHit.setGain(3);
  playerDie = minim.loadSample("audio/sfx/playerDie.mp3");
  playerWin = minim.loadSample("audio/sfx/playerWin.mp3");

  globalSamples.add(playerAttackSound);
  globalSamples.add(chickenSound);
  globalSamples.add(buttonClickSound);
  globalSamples.add(returnButtonClickSound);
  globalSamples.add(chickenDieSound);
  globalSamples.add(playerHit);
  globalSamples.add(playerDie);
  globalSamples.add(playerWin);

  defaultMusic = minim.loadFile("audio/music/defaultMusic.mp3");

  defaultMusic.setGain(-15);
  defaultMusic.play();

  tutorialHUD = loadImage("HUD/tutorialHUD.png");
  wIcon = loadImage("controlls/btn_controlls_w2.png");
  aIcon = loadImage("controlls/btn_controlls_a2.png");
  sIcon = loadImage("controlls/btn_controlls_s2.png");
  dIcon = loadImage("controlls/btn_controlls_d2.png");

  cameraX = 0;
  cameraY = 0;
  menuManager = new MenuManager(gameState);
  //menuManager.createInitialMenu();

  tiles = loadImage("tileset2.png");
  fundo = new Camada(80, 80, "camadaFundo2", 32, 32, tiles, 122);
  colisao = new Camada(80, 80, "camadaMeio2", 32, 32, tiles, 122);
  frente = new Camada(80, 80, "camadaFrente2", 32, 32, tiles, 122);

  //tilesTutorial = loadImage("tileset_tutorial.png");
  //fundoTutorial = new Camada(int l, int a, String nomeArquivo, int tLar, int tAlt, PImage tImage, int nTiles);
  //colisaoTutorial = new Camada(int l, int a, String nomeArquivo, int tLar, int tAlt, PImage tImage, int nTiles);
  //frenteTutorial = new Camada(int l, int a, String nomeArquivo, int tLar, int tAlt, PImage tImage, int nTiles);

  pv = new PVector(width/2, height/2);
  p = new Player(pv, 3, 3, 64, 64, 5, 1.5, 0.3, 1);
  //PVector pv, float vx, float vy, int hbw, int hbh, float maxVelocity, float acceleration, float fricction, int attackDamage

  crowd = new Crowd(p, 10);

  cursorDefault = loadImage("HUD/cursorDefault.png");
  cursor(cursorDefault, 0, 0);

  setupTutorialIdle();
}

void draw() {

  if (gameState != 1) {
    chickenSound.stop();
  }

  switch(gameState) {
  case 0:
    background(205, 223, 108);
    menuManager.createInitialMenu();
    gameState = menuManager.update(gameState);

    break;

  case 1:
    if (initialTime) {
      gameTimer = new GameTimer(5);
      //RESETAR TODOS OS VALORES PARA OS INICIAIS
      //p.reset();
      //crowd.reset();

      pv = new PVector(width/2, height/2);
      p = new Player(pv, 3, 3, 64, 64, 5, 1.5, 0.3, 1);
      //PVector pv, float vx, float vy, int hbw, int hbh, float maxVelocity, float acceleration, float fricction, int attackDamage
      crowd = new Crowd(p, 10);

      cameraX = 0;
      cameraY = 0;


      initialTime = false;
    }

    if (!gameTimer.paused) {

      background(80);
      fundo.exibir(1);
      colisao.exibir(1);
      if (crowd.enemiesList.isEmpty()) {
        crowd.create(p);
      }

      if (attackPressed) {
        if (mouseButton == LEFT) {
          p.attack();
        } else {
          p.bulletAttack();
        }
      }


      crowd.update(p);

      p.updateAttacks();
      p.dash(moveUp, moveDown, moveRight, moveLeft, dashPressed);
      p.move(moveUp, moveDown, moveRight, moveLeft, crowd.enemiesList);
      dashPressed = false;

      gameTimer.update();
      gameTimer.draw();

      frente.exibir(1);

      ajustarCamera(p, 100);
    } else {
      //text("Pausado", width/2, height/2);
      initialTime = true;
      gameTimer.paused = false;
      //gameState = 0;
    }

    if (!p.isAlive() || !gameTimer.isActive()) {
      gameState = 0;
      initialTime = true;
    }

    if (!p.isAlive()) {
      playerDie.trigger();
    }

    if (quitGame) {
      gameState = 0;
      initialTime = true;
    }
    break;

  case 2:
    background(205, 223, 108);
    menuManager.createOptionsMenu();
    gameState = menuManager.update(gameState);
    break;

  case 3:
    background(205, 223, 108);
    menuManager.createCreditsMenu();
    gameState = menuManager.update(gameState);
    break;

  case 4:
    background(0);
    String text;
    if (!p.isAlive()) {
      text = "Voce perdeu! KKKKKKKKKK";
    } else {
      text = "Você conseguiu sobreviver!";
    }
    textAlign(CENTER);
    text(text, width/2, height/2);
    break;

  case 5:
    //Area de tutorial
    //fundoTutorial.exibir(1);
    //colisaoTutorial.exibir(1);

    //frenteTutorial.exibir(1);

    background(205, 223, 108);
    image(tutorialHUD, 100, 50);

    if (moveUp) {
      wIcon = loadImage("controlls/btnPressed_controlls_w2.png");
    } else {
      wIcon = loadImage("controlls/btn_controlls_w2.png");
    }

    if (moveLeft) {
      aIcon = loadImage("controlls/btnPressed_controlls_a2.png");
    } else {
      aIcon = loadImage("controlls/btn_controlls_a2.png");
    }

    if (moveDown) {
      sIcon = loadImage("controlls/btnPressed_controlls_s2.png");
    } else {
      sIcon = loadImage("controlls/btn_controlls_s2.png");
    }

    if (moveRight) {
      dIcon = loadImage("controlls/btnPressed_controlls_d2.png");
    } else {
      dIcon = loadImage("controlls/btn_controlls_d2.png");
    }

    image(wIcon, 250, 80);
    image(aIcon, 190, 140);
    image(sIcon, 250, 140);
    image(dIcon, 310, 140);

    //Idle do personagem
    if (attacking) {
      if (atkAni.disparou()) {
        atkFrame++;
        if (atkFrame >= atkFrames) {
          atkFrame = 0;
          attacking = false;
        }
      }


      int linhaAtk = (direcao == 2) ? 4 : 5;
      image(sprites[linhaAtk][atkFrame], 200, height*0.4);
    } else {
      // parado (idle)
      int linhaIdle = direcao;
      image(sprites[linhaIdle][0], 200, height*0.4);
    }

    // Animação do inimigo (idle para esquerda)
    if (enemyIdleAni.disparou()) {       // usa um timer separado para o inimigo
      enemyIdleFrame = (enemyIdleFrame + 1) % 4;  // 4 frames por linha
    }

    int linhaIdle = 2; // linha 4 do spritesheet (esquerda), índice 3
    image(enemySprites[linhaIdle][enemyIdleFrame], 170, height*0.77);


    if (clockIdle.disparou()) {
      currentClockSprite++;
      if (currentClockSprite >= 9) {
        currentClockSprite = 1;
      }
    }

    clockSprite = loadImage("HUD/timer/timer" + currentClockSprite + ".png");

    image(clockSprite, 260, height * 0.7);

    returnButton.draw();

    if (returnButton.collision()) {
      returnButtonClickSound.trigger();
      gameState = returnButton.value;
    }

    break;

  case 6:
    background(205, 223, 108, 200);
    menuManager.createPauseMenu();
    gameState = menuManager.update(gameState);
    break;
  }
}

void setupTutorialIdle() {
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

  atkAni = new Timer(700/4);

  PImage auxG = loadImage("characters/chicken/galinhaIdle.png");
  auxG.resize(64*4*1, 64*4*1);

  enemySprites = new PImage[4][4];
  for (int i=0; i<4; i++) {
    for (int j=0; j<4; j++) {
      enemySprites[i][j] = auxG.get(j*64, i*64, 64, 64);
    }
  }

  enemyIdleAni = new Timer(1000/4);
  clockIdle = new Timer(1000);
  currentClockSprite = 1;

  returnButtonPV = new PVector(width*0.02, height*0.05);
  returnButton = new Button(returnButtonPV, 128, 128, "", "HUD/returnIcon", 0);
}

void keyPressed() {
  switch(key) {
  case 'w':
    moveUp = true;
    break;

  case 'a':
    moveLeft = true;
    lastSide = 'l';
    break;

  case 's':
    moveDown = true;
    break;

  case 'd':
    moveRight = true;
    lastSide = 'r';
    break;

  case ' ':
    dashPressed = true;
    break;

  case 'p':
    if (!gameTimer.paused) {
      gameTimer.pause();
      gameState = 6;
    } else {
      gameTimer.resume();
      gameState = 1;
    }

    break;
  }
}

void keyReleased() {
  switch(key) {
  case 'w':
    moveUp = false;
    break;

  case 'a':
    moveLeft = false;
    break;

  case 's':
    moveDown = false;
    break;

  case 'd':
    moveRight = false;
    break;
  }
}

void mousePressed() {
  if (gameState == 1) {
    if (mouseButton == LEFT || mouseButton == RIGHT) {
      attackPressed = true;
    }
  } else if (gameState == 5) {
    if (!attacking) {
      attacking = true;
      atkFrame = 0;
      atkAni.reset();
    }
  }
}

void mouseReleased() {
  attackPressed = false;
}

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

Minim minim;
AudioSample playerAttackSound;

PImage cursorDefault;

void setup() {
  size(900, 700);
  //fullScreen();
  cameraX = 0;
  cameraY = 0;
  menuManager = new MenuManager(gameState);
  //menuManager.createInitialMenu();

  tiles = loadImage("tileset.png");
  fundo = new Camada(80, 80, "camadaFundo", 32, 32, tiles, 55);
  colisao = new Camada(80, 80, "camadaMeio", 32, 32, tiles, 55);
  frente = new Camada(80, 80, "camadaFrente", 32, 32, tiles, 55);

  //tilesTutorial = loadImage("tileset_tutorial.png");
  //fundoTutorial = new Camada(int l, int a, String nomeArquivo, int tLar, int tAlt, PImage tImage, int nTiles);
  //colisaoTutorial = new Camada(int l, int a, String nomeArquivo, int tLar, int tAlt, PImage tImage, int nTiles);
  //frenteTutorial = new Camada(int l, int a, String nomeArquivo, int tLar, int tAlt, PImage tImage, int nTiles);

  pv = new PVector(width/2, height/2);
  p = new Player(pv, 3, 3, 64, 64, 5, 1.5, 0.3, 30);
  //PVector pv, float vx, float vy, int hbw, int hbh, float maxVelocity, float acceleration, float fricction, int attackDamage

  crowd = new Crowd(p);
  
  minim = new Minim(this);  
  playerAttackSound = minim.loadSample("audio/sfx/playerHit.mp3");
  
  
  cursorDefault = loadImage("HUD/cursorDefault.png");
  cursor(cursorDefault, 0, 0);
}

void draw() {
  switch(gameState) {
  case 0:
    background(200);
    menuManager.createInitialMenu();
    gameState = menuManager.update(gameState);

    break;

  case 1:
    if (initialTime) {
      gameTimer = new GameTimer(30);
      //RESETAR TODOS OS VALORES PARA OS INICIAIS
      p.reset();
      crowd.reset();

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
      gameState = 0;
    }

    if (!p.isAlive() || !gameTimer.isActive()) {
      gameState = 4;
    }

    if (quitGame) {
      gameState = 0;
    }
    break;

  case 2:
    background(200);
    menuManager.createOptionsMenu();
    gameState = menuManager.update(gameState);
    break;

  case 3:
    background(200);
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
  }
}

class Item {
}
class Weapon extends Item {
}
class Utility extends Item {
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
    } else {
      gameTimer.resume();
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
  if (mouseButton == LEFT || mouseButton == RIGHT) {
    attackPressed = true;
  }
}

void mouseReleased() {
  attackPressed = false;
}

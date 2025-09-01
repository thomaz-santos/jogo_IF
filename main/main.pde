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


void setup() {
  size(1200, 800);
  cameraX = 0;
  cameraY = 0;

  menuManager = new MenuManager(gameState);
  //menuManager.createInitialMenu();

  tiles = loadImage("tileset.png");
  fundo = new Camada(80, 80, "camadaFundo", 32, 32, tiles, 53);
  colisao = new Camada(80, 80, "camadaMeio", 32, 32, tiles, 53);
  frente = new Camada(80, 80, "camadaFrente", 32, 32, tiles, 53);

  pv = new PVector(width/2, height/2);
  p = new Player(pv, 4.5, 4.5, 32, 32); //PVector pv, float vx, float vy, int hbw, int hbh

  crowd = new Crowd(10, p);
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
      gameTimer = new GameTimer(60);
      //RESETAR TODOS OS VALORES PARA OS INICIAIS
      //p.reset();
      //crowd.reset();

      initialTime = false;
    }

    if (!gameTimer.paused) {
      
      background(200);
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
      text("Pausado", width/2, height/2);
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
    if(!gameTimer.paused) {
      gameTimer.pause();
    } else {
      gameTimer.resume();
    }
    
    break;

  case 'n':
    crowd = new Crowd((int) random(5, 10), p);
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

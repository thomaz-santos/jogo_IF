int gameState = 0;
MenuManager menuManager;

Timer t = new Timer(5000);
//Timer gameTime = new Timer(10000);

float velocidadeMax;
boolean moveUp, moveDown, moveRight, moveLeft, attackPressed, quitGame;
char lastSide;
PVector pv;
Player p;

Crowd crowd;
GameTimer gameTimer;
boolean initialTime;

void setup() {
  size(1600, 900);
  menuManager = new MenuManager(gameState);
  //menuManager.createInitialMenu();
  
  pv = new PVector(width/2, height/2);
  p = new Player(pv, 4.5, 4.5, 50, 60); //PVector pv, float vx, float vy, int hbw, int hbh
  
  crowd = new Crowd(10, p);
}

void draw() {
  switch(gameState) {
  case 0:  
    background(200);
    menuManager.createInitialMenu();
    gameState = menuManager.update(gameState);
    initialTime = true;
    
    break;

  case 1:
    if (initialTime) {
      gameTimer = new GameTimer(10);
      //RESETAR TODOS OS VALORES PARA OS INICIAIS
      
      initialTime = false;
    }
    
    background(80);

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
    p.move(moveUp, moveDown, moveRight, moveLeft, crowd.enemiesList);
    //e.move(p);

    gameTimer.update();
    gameTimer.draw();

    if (!p.isAlive() || !gameTimer.isActive()) {
      gameState = 4;
    }
    
    if(quitGame) {
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

  case 'p':
    quitGame = true;
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

  case 'p':
    quitGame = false;
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

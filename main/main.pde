int gameState = 1;
Timer t = new Timer(5000);

float velocidadeMax;
boolean moveUp, moveDown, moveRight, moveLeft, attackPressed, quitGame;
PVector pv = new PVector(400, 300);
PVector ev = new PVector(400, 500);
Player p = new Player(pv, 10, 10, 50, 60); //PVector pv, int vx, int vy, int hbw, int hbh
Enemy e = new Enemy(ev, 2, 2, 30, 60, 100);

void setup() {
  size(800, 600);
}

void draw() {
  switch(gameState) {
  case 0:
    text("Hello!", width/2, height/2);
    if (t.disparou()) {
      gameState++;
    }
    break;

  case 1:
    //println("attack: " + attackPressed);
    background(80);

    if (attackPressed) {
      if (moveLeft) {
        p.attack('l');
      } else {
        p.attack('r');
      }
    }

    p.updateAttacks();
    p.move(moveUp, moveDown, moveRight, moveLeft, e);
    e.move(p);

    if (quitGame) {
      gameState = 4;
    }
    break;

  case 4:
    background(0);
    text("Obrigado!", width/2, height/2);
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
    break;

  case 's':
    moveDown = true;
    break;

  case 'd':
    moveRight = true;
    break;

  case 'p':
    quitGame = true;
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

  case 'p':
    quitGame = false;
    break;
  }
}

void mousePressed() {
  attackPressed = true;
}

void mouseReleased() {
  attackPressed = false;
}

int gameState = 1;
Timer t = new Timer(5000);

float velocidadeMax;
boolean moveUp, moveDown, moveRight, moveLeft, attackPressed, quitGame;
char lastSide;
PVector pv = new PVector(400, 300);
PVector ev = new PVector(400, 500);
Player p = new Player(pv, 10, 10, 50, 60); //PVector pv, int vx, int vy, int hbw, int hbh
//Enemy e = new Enemy(ev, 2, 2, 30, 60, 100);

Crowd crowd = new Crowd(10);

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
      p.attack(lastSide);
    }



    crowd.update(p);

    p.updateAttacks();
    p.move(moveUp, moveDown, moveRight, moveLeft, crowd.enemiesList);
    //e.move(p);

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
    crowd = new Crowd((int) random(1, 10));
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

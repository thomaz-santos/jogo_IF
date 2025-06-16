float velocidadeMax;
boolean moveUp, moveDown, moveRight, moveLeft;
PVector pv = new PVector(400, 300);
PVector ev = new PVector(400, 500);
Player p = new Player(pv, 10, 10, 60, 60);
Enemy e = new Enemy(ev, 5, 5, 60, 60);

void setup() {
  size(800, 600);  
}

void draw() {
  background(80);
  p.move(moveUp, moveDown, moveRight, moveLeft);
  e.move(p);
}

class Item {}
class Weapon extends Item{}
class Utility extends Item{}

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
      

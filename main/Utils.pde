class Timer {
  private long tempoAtual;
  private long ultimoTempo;
  private int intervalo;

  public Timer(int intervalo) {
    this.intervalo=intervalo;
    ultimoTempo= millis();
  }

  public boolean disparou() {
    tempoAtual=millis();
    if (tempoAtual-ultimoTempo>intervalo) {
      ultimoTempo=ultimoTempo+intervalo;
      return true;
    }
    return false;
  }
  
  public void reset() {
    ultimoTempo = millis();
  }
}

class GameTimer {
  int duration;
  int endTime;
  int currentTime;
  boolean active = true;
  boolean paused = false;
  
  PImage sprite;
  
  int pauseStartTime = 0;  // Armazena o tempo em que a pausa começou


  float step;
  int currentSprite;
  public GameTimer(int d) {
    this.duration = d * 1000;
    this.currentTime = millis();
    this.endTime = currentTime + duration;
    
    
    this.step = duration/8;
    //this.sprite = loadImage("HUD/timer/timer1.png");
  }

  void update() {
    if (!this.paused) {
      this.currentTime = millis();

      if (this.currentTime >= endTime) {
        this.active = false;
      }

      this.draw();
    } else {
      this.draw(); // Ainda desenha, mas o tempo fica parado
    }
  }

  void pause() {
    if (!this.paused) {
      this.paused = true;
      this.pauseStartTime = millis();  // Marca o tempo em que foi pausado
    }
  }

  void resume() {
    if (this.paused) {
      int pauseDuration = millis() - this.pauseStartTime;  // Quanto tempo ficou pausado
      this.endTime += pauseDuration;  // Adiciona esse tempo ao fim
      this.paused = false;
    }
  }

  boolean isActive() {
    return this.active;
  }

  void draw() {
    fill(240, 255, 246);
    textAlign(CENTER);
    textSize(30);
    if((endTime - millis())/1000 >= 0) {
      text((endTime - millis()) / 1000, width / 2, height * 0.16);
    } else {
      text(0, width / 2, height * 0.16);
    }
    
    textAlign(LEFT);
    
    this.currentSprite = ceil(currentTime/step);
    if(currentSprite >= 9) {currentSprite = 1;}
    
    this.sprite = loadImage("HUD/timer/timer" + this.currentSprite + ".png");
    
    image(this.sprite, width / 2 - (this.sprite.width/2), height * 0.03);
  }
}

void ajustarCamera(Player p1, float margem)
{
  if (cameraX<p1.positionVector.x+p1.hitboxWidth+margem-width)
    cameraX=p1.positionVector.x+p1.hitboxWidth+margem-width;
  if (cameraX>p1.positionVector.x-margem)
    cameraX=p1.positionVector.x-margem;

  if (cameraY<p1.positionVector.y+p1.hitboxHeight+margem-height)
    cameraY=p1.positionVector.y+p1.hitboxHeight+margem-height;
  if (cameraY>p1.positionVector.y-margem)
    cameraY=p1.positionVector.y-margem;
}

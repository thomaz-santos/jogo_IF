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
}

class GameTimer {
  int duration;
  int endTime;
  int currentTime;
  boolean active = true;
  boolean paused = false;

  public GameTimer(int d) {
    this.duration = d*1000;

    this.currentTime = millis();
    this.endTime = currentTime + duration;
  }

  void update() {
    if (!this.paused) {
      this.currentTime = millis();

      if (this.currentTime >= endTime) {
        this.active = false;
      }

      this.draw();
    } else {
      this.draw();
    }
  }

  void pause() {
    this.paused = true;
  }

  void resume() {
    this.paused = false;
  }

  boolean isActive() {
    return this.active;
  }

  void draw() {
    fill(240, 255, 246);
    text(this.currentTime/1000, width/2, height*0.08);
  }
}

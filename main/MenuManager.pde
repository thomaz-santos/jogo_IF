class MenuManager {
  ArrayList<Button> menuButtonsList = new ArrayList<Button>();
  int gameState;
  GameTimer gameTimer;

  public MenuManager(int gm) {
    this.gameState = gm;
  }

  void createInitialMenu() {
    this.menuButtonsList.clear();
    int[] colorCode = {4, 89, 42};
    PVector pv1 = new PVector(width/2 - (width*0.3)/2, height * 0.6);
    PVector pv2 = new PVector(width/2 - (width*0.3)/2, height * 0.7);
    PVector pv3 = new PVector(width/2 - (width*0.3)/2, height * 0.8);

    Button b1 = new Button(pv1, width*0.3, 75, "Jogar", colorCode, 1);
    Button b2 = new Button(pv2, width*0.3, 75, "Opções", colorCode, 2);
    Button b3 = new Button(pv3, width*0.3, 75, "Créditos", colorCode, 3);

    this.menuButtonsList.add(b1);
    this.menuButtonsList.add(b2);
    this.menuButtonsList.add(b3);
  }

  void createOptionsMenu() {
    this.menuButtonsList.clear();
    int[] colorCode = {4, 89, 42};

    PVector pv1 = new PVector(width*0.02, height*0.04);

    Button b1 = new Button(pv1, width*0.15, 50, "Voltar", colorCode, 0);

    this.menuButtonsList.add(b1);
  }

  void createCreditsMenu() {
    this.menuButtonsList.clear();
    int[] colorCode = {4, 89, 42};

    PVector pv1 = new PVector(width*0.02, height*0.04);

    Button b1 = new Button(pv1, width*0.15, 50, "Voltar", colorCode, 0);

    this.menuButtonsList.add(b1);
  }

  void createPauseMenu() {
    this.menuButtonsList.clear();
    int[] colorCode = {4, 89, 42};

    PVector pv1 = new PVector(width/2, height*0.4);
    PVector pv2 = new PVector(width/2, height*0.5);

    Button b1 = new Button(pv1, width*0.15, 50, "Jogar", colorCode, 1);
    Button b2 = new Button(pv2, width*0.15, 50, "Voltar ao menu", colorCode, 0);

    this.menuButtonsList.add(b1);
    this.menuButtonsList.add(b2);
  }

  int update(int gm) {
    this.draw(gm);

    if (!menuButtonsList.isEmpty()) {
      for (int i = 0; i < this.menuButtonsList.size(); i++) {
        Button b = menuButtonsList.get(i);

        if (b.collision()) {
          return b.value;
        }
      }
    }

    return gameState;
  }

  void draw(int gm) {
    this.gameState = gm;

    switch(this.gameState) {
    case 0:
      textAlign(CENTER);
      textSize(150);
      fill(4, 89, 42);
      text("Wave Game", width/2, height*0.3);

      for (Button b : this.menuButtonsList) {
        b.draw();
      }

      break;

    case 2:
      textAlign(CENTER);
      textSize(80);
      fill(4, 89, 42);
      text("Área em construção! \nVolte daqui um tempo para ver se algo mudou", width/2, height/2);

      for (Button b : this.menuButtonsList) {
        b.draw();
      }

      break;

    case 3:
      textAlign(CENTER);
      textSize(80);
      fill(4, 89, 42);
      text("Jogo (está sendo) feito por:", width/2, height*0.2);
      textSize(60);
      text("Letícia Campeão", width/2, height*0.4);
      text("Ruan Gustavo Novello Correa", width/2, height*0.5);
      text("Thomaz Vieira dos Santos", width/2, height*0.6);
      text("Vitor Simonetti Fantucci", width/2, height*0.7);

      for (Button b : this.menuButtonsList) {
        b.draw();
      }

      break;

    case 5:
      fill(20, 20, 20, 170);
      rect(0, 0, width, height);

      for (Button b : this.menuButtonsList) {
        b.draw();
      }
      
      break;
    }
  }
}

class Button {
  PVector positionVector;
  float hitboxWidth, hitboxHeight;
  String text;
  int[] colorCode = new int[3];
  int value;

  public Button(PVector pv, float hitboxWidth, float hitboxHeight, String text, int[] colorCode, int v) {
    this.positionVector = pv;
    this.hitboxWidth = hitboxWidth;
    this.hitboxHeight = hitboxHeight;
    this.text = text;
    this.colorCode = colorCode.clone();
    this.value = v;
  }

  void draw() {
    fill(this.colorCode[0], this.colorCode[1], this.colorCode[2]);
    rect(this.positionVector.x, this.positionVector.y, this.hitboxWidth, this.hitboxHeight);

    textAlign(CENTER);
    textSize(40);
    fill(255);
    text(this.text, this.positionVector.x + (this.hitboxWidth/2), this.positionVector.y + (this.hitboxHeight*0.7));
  }

  boolean collision() {
    if (mousePressed) {
      return (
        mouseX > this.positionVector.x && mouseX < this.positionVector.x + this.hitboxWidth &&
        mouseY > this.positionVector.y && mouseY < this.positionVector.y + this.hitboxHeight
        );
    }

    return false;
  }
}

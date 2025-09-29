class MenuManager {
  ArrayList<Button> menuButtonsList = new ArrayList<Button>();
  int gameState;
  GameTimer gameTimer;
  
  PImage menuTitle;

  public MenuManager(int gm) {
    this.gameState = gm;
  }

  void createInitialMenu() {
    PImage buttonImageReference;
    buttonImageReference = loadImage("HUD/menuButtons/playButton.png");
    buttonImageReference.resize(buttonImageReference.width/2,buttonImageReference.height/2);
    
    this.menuButtonsList.clear();
    PVector pv1 = new PVector(width/2 - (buttonImageReference.width/2), height * 0.45 + height*0.02);
    PVector pv2 = new PVector(width/2 - (buttonImageReference.width/2), height * 0.55 + height*0.02*2);
    PVector pv3 = new PVector(width/2 - (buttonImageReference.width/2), height * 0.65 + height*0.02*3);
    PVector pv4 = new PVector(width/2 - (buttonImageReference.width/2), height * 0.75 + height*0.02*4);
//width/2 - (width*0.3)/2, height * 0.4 + height*0.01

    Button b1 = new Button(pv1, buttonImageReference.width, buttonImageReference.height, "Jogar", "HUD/menuButtons/playButton.png", 1);
    Button b2 = new Button(pv2, buttonImageReference.width, buttonImageReference.height, "Opções", "HUD/menuButtons/optionsButton.png", 2);
    Button b3 = new Button(pv3, buttonImageReference.width, buttonImageReference.height, "Créditos", "HUD/menuButtons/creditsButton.png", 3);
    Button b4 = new Button(pv4, buttonImageReference.width, buttonImageReference.height, "Tutorial", "HUD/menuButtons/tutorialButton.png", 5);

    this.menuButtonsList.add(b1);
    this.menuButtonsList.add(b2);
    this.menuButtonsList.add(b3);
    this.menuButtonsList.add(b4);
    
    this.menuTitle = loadImage("HUD/menuTitle3.png");
  }

  void createOptionsMenu() {
    this.menuButtonsList.clear();

    PVector pv1 = new PVector(width*0.02, height*0.04);

    Button b1 = new Button(pv1, 320, 128, "Voltar", "HUD/menuButtons/exitButton.png", 0);

    this.menuButtonsList.add(b1);
  }

  void createCreditsMenu() {
    this.menuButtonsList.clear();

    PVector pv1 = new PVector(width*0.02, height*0.04);

    Button b1 = new Button(pv1, 320, 128, "Voltar", "HUD/menuButtons/exitButton.png", 0);

    this.menuButtonsList.add(b1);
  }

  void createPauseMenu() {
    this.menuButtonsList.clear();

    PVector pv1 = new PVector(width/2, height*0.4);
    PVector pv2 = new PVector(width/2, height*0.5);

    Button b1 = new Button(pv1, 320, 128, "Jogar", "HUD/menuButtons/playButton.png", 1);
    Button b2 = new Button(pv2, 320, 128, "Voltar ao menu", "HUD/menuButtons/exitButton.png", 0);

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
      image(this.menuTitle, width/2 - (menuTitle.width/2), height*0.05);

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
  String imagePath;
  int value;
  PImage sprite;

  public Button(PVector pv, float hitboxWidth, float hitboxHeight, String text, String path, int v) {
    this.positionVector = pv;
    this.hitboxWidth = hitboxWidth;
    this.hitboxHeight = hitboxHeight;
    this.text = text;
    this.imagePath = path;
    this.value = v;
    
    this.sprite = loadImage(this.imagePath);
    this.sprite.resize(sprite.width/2,sprite.height/2);
    this.hitboxWidth = sprite.width;
    this.hitboxHeight = sprite.height;
  }

  void draw() {
    image(this.sprite, this.positionVector.x, this.positionVector.y);
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

class Slider {
  Button icon;
  float start, end;
  int y;
  float minValue, maxValue, value;
  
  public Slider(String iconPath, int y, float start, float end, float min, float max) {
    this.icon = new Button(new PVector(start, y), iconPath);
    this.start = start;
    this.end = end;
    this.y = y;
    this.minValue = min;
    this.maxValue = max;
  }
  
  public Slider() {}
  
  void atualizar() {
    if(this.icon.collision()) {
      if(mouseX >= start && mouseX <= end+start) {
        icon.positionVector.x = mouseX - icon.hitboxWidth/2; 
        value = map(icon.positionVector.x, start, end+start, minValue, maxValue);
      }
    }
    
    
    println(value);
  }
  
  void desenhar() {
    stroke(115, 62, 57);
    strokeWeight(4);
    fill(234, 212, 170);
    rect(start, y+icon.hitboxHeight*0.22, end, height*0.05);
    
    strokeWeight(4);
    stroke(0);
    //icon.positionVector.x = start + value;
    icon.draw();
  }
}

class Button {
  String name;//name of button
  String displayText = "";//text displayed on button
  boolean hasText = false;//if text is to be displayed
  String selector = "";//selector name button is apart of
  boolean hovering = false;//is button being hovered over
  boolean selected = false;//if button is selected
  boolean beingClicked = false;//if button is being clicked on
  PVector size = new PVector();//size of button
  PVector position = new PVector();//position of button
  PImage icon;//button icon
  boolean toggle = false;//is button toggle or pulse
  boolean mouseWasPressed = false;//mouse was pressed last frame
  
  Button(float x, float y, float sizeX, float sizeY, boolean toggle, String name, String icon, boolean hasText, String text) {//standard button
    position.set(x,y);
    size.set(sizeX, sizeY);
    this.hasText = hasText;
    if(hasText) this.displayText = text;
    this.icon = loadImage(icon);
    this.toggle = toggle;
    this.name = name;
  }
  
  Button(float x, float y, float sizeX, float sizeY, boolean toggle, String name, String selector, String icon, boolean hasText, String text) {//button in a selector
    this(x, y, sizeX, sizeY, toggle, name, icon, hasText, text);
    this.selector = selector;
  }
  
  void run() {//run button
    update();
    render();
  }
  
  void update() {
    if(!mousePressed && !toggle) selected = false;//if mouse is not pressed and button is pulse, set selected to false
    if(mouseX > position.x - size.x/2 && mouseX < position.x + size.x/2 && mouseY > position.y - size.y/2 && mouseY < position.y + size.y/2) {//if mouse is over button
      if(!mousePressed) {//if not pressed set hovering, call hover event
        hovering = true;
        buttonEvent(selector, name, -1);
        if(mouseWasPressed && beingClicked) {//if mouse was being pressed in previous frame and button was being clicked on
          selected = !selected;//toggle selected
          int a = 0;
          if(selected) a = 1;
          buttonEvent(selector, name, a);//call click event, 1 for on, 0 for off
        }
      } else if(mouseIsPressed == false) {//if mouse is pressed and was not already pressed outside of the button
        beingClicked = true;//set being clicked
        mouseWasPressed = true;//set was pressed
      }
    } else hovering = false;//if mouse isn't over button set hovering
    if(!mousePressed) {//if mouse not pressed set appropriate variables
      mouseWasPressed = false;
      beingClicked = false;
    }
  }
  
  void render() {
    imageMode(CENTER);
    rectMode(CENTER);
    if(selected) fill(255, 0, 0);//select color based on state
    else if(beingClicked) fill(0,0,255);
    else if(hovering) fill(0, 255, 0);
    else fill(255);
    rect(position.x, position.y, size.x, size.y);//draw rectanlge
    image(icon, position.x, position.y, size.x, size.y);//display icon
    if(hasText) {//display text
      textAlign(CENTER);
      fill(0);
      textSize(size.x/4);
      text(displayText, position.x, position.y+size.y/8);
    }
  }
}

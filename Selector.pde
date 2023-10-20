class Selector {
  String name;//name of selector
  ArrayList<Button> buttons = new ArrayList<Button>();//array list of buttons that make up the selector
  ArrayList<String> selectedButtons;//array list of buttons that are selected
  PVector position = new PVector(0,0);//position of selector
  int maxListSize = 0;//max amount of buttons that can be selected
  int minListSize;//min amount of buttons that can be selected
  String[] buttonIcons;//list of file names of button icons
  boolean numbered = false;//if the buttons should display a number based on their position in the selector
  int startNum = 0;//starting number of display numbers
  
  Selector(float x, float y, int buttonAmount, float buttonSizeX, float buttonSizeY, int minSelected, int maxSelected, boolean horizontal, String name, String[] icons, boolean numbered, int startNum) {//standard selector
    this.numbered = numbered;
    this.startNum = startNum;
    position.set(x,y);
    selectedButtons = new ArrayList<String>();
    if(maxSelected >= 0) maxListSize = maxSelected;
    minListSize = minSelected;
    this.name = name;
    for(int i = 0; i < buttonAmount; i++){
      String icon = "Empty.png";
      if(i < icons.length) icon = icons[i];
      float buttonX = 0;
      float buttonY = 0;
      float spacing = buttonSizeX/4;
      if(!horizontal) spacing = buttonSizeY/4;
      if(buttonAmount%2 == 0) {//following math is to generate bricks in a centered manner
        if(horizontal) buttonX = (position.x + (buttonSizeX + spacing)*(i-(buttonAmount/2-1)) - (buttonSizeX + spacing)/2);
        else buttonY = (position.y + (buttonSizeY + spacing)*(i-(buttonAmount/2-1)) - (buttonSizeY + spacing)/2);
      } else {
        if(horizontal) buttonX = position.x + (buttonSizeX + spacing)*(i-(buttonAmount-1)/2);
        else buttonY = position.y + (buttonSizeY + spacing)*(i-(buttonAmount-1)/2);
      }
      if(horizontal) buttonY = position.y;
      else buttonX = position.x;
      if(numbered) buttons.add(new Button(buttonX, buttonY, buttonSizeX, buttonSizeY, true, str(i), name, icon, true, str(startNum+i)));
      else buttons.add(new Button(buttonX, buttonY, buttonSizeX, buttonSizeY, true, str(i), name, icon, false, ""));
    }
  }
  Selector(float x, float y, int buttonAmount, float buttonSizeX, float buttonSizeY, int minSelected, int maxSelected, boolean horizontal, String name, String[] icons){//selector with just icons
    this(x, y, buttonAmount, buttonSizeX, buttonSizeY, minSelected, maxSelected, horizontal, name, icons, false, 0);
  }
  Selector(float x, float y, int buttonAmount, float buttonSizeX, float buttonSizeY, int minSelected, int maxSelected, boolean horizontal, String name, boolean numbered, int startNum){//selector with just numbers
    this(x, y, buttonAmount, buttonSizeX, buttonSizeY, minSelected, maxSelected, horizontal, name, new String[]{}, numbered, startNum);
  }
  
  void run() {//run selecrtor
    for(Button b : buttons) {//for all buttons in selector
      b.run();//run button
    }
    update();
  }
  void update() {
    for(Button b : buttons) {
      boolean inSelectedList = isSelected(b.name);
      if(b.selected && !inSelectedList) selectedButtons.add(b.name);//if selected and not on selected list, add to selected list
      if(!b.selected && inSelectedList) {//if not selected and is on the selected list
        if(selectedButtons.size() > minListSize) selectedButtons.remove(b.name);//if minimun selected requirement would still be fulfilled, remove from selected list
        else b.selected = true;//else set back to true
      }
    }
    while(selectedButtons.size() > maxListSize) selectedButtons.remove(0);//if maximum selected is exceeded, remove first button on selected list until requirement is met
    for(Button b : buttons) {//for all button that are selected and not on the selected list, deselect
      if(b.selected && !isSelected(b.name)) b.selected = false;
    }
  }
  ArrayList<String> getSelectedButtons() {//returns array list of selected buttons
    update();
    return selectedButtons;
  }
  boolean isSelected(String button) {//returns true if button is on selected button list, false otherwise
    for(String str : selectedButtons) {
      if(str.equals(button)) return true;
    }
    return false;
  }
}

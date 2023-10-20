int targetFrameRate = 60;//framerate to run the sketch at
float SFC;//Scaling Factor Constant, used to scale sizes of objects in relation to screen size
float SFW;//Scaling Factor Width
float SFH;//Scaling Factor Height
PFont gameFont;//game font
PImage menu;//menu background
boolean gameActive = false;//whether the game is active
boolean mouseIsPressed = false;//global mouse variable for buttons to reference
String descriptionText = "";//perk description to be displayed
PImage mapDisplay;//current map preview to be displayed
String[] mapImgFiles = new String[] {"map1Screenshot.jpg", "map2Screenshot.jpg", "map3Screenshot.jpg", "map4Screenshot.jpg", "map5Screenshot.jpg", "map6Screenshot.jpg"};
PImage[] mapImgs = new PImage[6];
Game game;//current game object
String[] perkList = new String[] {"speed", "3 jump", "damage", "1/2 reload", "3xbullet speed", "extra ammo"};//list of available player perks (strings are for human reference only, length is the only thing referenced by code)
String[] perkIconList = new String[] {"playerSpeed.png", "tripleJump.png", "damageIncrease.png", "reloadSpeed.png", "bulletSpeed.png", "extraAmmo.png"};//icons for the player perks
String[] playerImgFiles = new String[] {"player1.png", "player2.png", "player3.png"};//player image file names
PImage[] playerImgs = new PImage[playerImgFiles.length];//player image array
String[] controlsImgFiles = new String[] {"player1Keys.png", "player2Keys.png", "player3Keys.png"};//player controls image file names
PImage[] controlsImgs = new PImage[controlsImgFiles.length];//player controls image array
ArrayList<float[]> playerImgCoords;//coords for player images
ArrayList<Selector> playerPerkSelectors;//player perk selectors
Selector playerCount;//number of players selector
Selector mapSelector;//map selector
Selector livesSelector;//number of lives selector
Button playButton;//button to create and start game

void setup() {
  fullScreen(P2D, 1);//set size and renderer
  frameRate(targetFrameRate);//set frame rate
  SFW = (1/1300.0)*width;//calculate width scaling factor
  SFH = (1/800.0)*height;//calculate height scaling factor
  SFC = SFW*SFH;//generate screen scaling factor
  gameFont = createFont("Outrun future.otf", 100*sqrt(SFC));//load game font
  menu = loadImage("menu.jpg");//load menu background
  playerCount = new Selector(2*width/8, 8*height/9, 2, SFW*50, SFH*50, 1, 1, true, "playerCount", true, 2);//create player count selector
  playerCount.buttons.get(0).selected = true;//select 2 players by default
  generatePerkSelectors(2, width/2, height/6, SFW*50, SFH*50);//create perk selectors based on player count
  livesSelector = new Selector(3*width/16, 11*height/15, 5, SFW*50, SFH*50, 1, 1, true, "livesSelector", true, 1);//create life count selector
  livesSelector.buttons.get(2).selected = true;//select 3 lives by default
  mapSelector = new Selector(13*width/18, 34*height/36, 6, SFW*80, SFH*50, 1, 1, true, "mapSelector", true, 1);//create map selector
  mapSelector.buttons.get(0).selected = true;//select map 1 by default
  playButton = new Button(width/8, 8*height/9, SFW*150, SFH*100, false, "play button", "Empty.png", true, "PLAY");//create play button
  for(int i = 0; i < mapImgFiles.length; i++) {//load map preview images
    mapImgs[i] = loadImage(mapImgFiles[i]);
  }
  mapDisplay = mapImgs[0];//set map 1 as display image
  for(int i = 0; i < playerImgFiles.length; i++) {//load player images
    playerImgs[i] = loadImage(playerImgFiles[i]);
  }
  for(int i = 0; i < controlsImgFiles.length; i++) {//load player controls images
    controlsImgs[i] = loadImage(controlsImgFiles[i]);
  }
  
  
}
void draw() {
  background(0);
  if(gameActive) {//if game is active run game, else run menu function
    game.run();
  } else {
    menu();
  }
}

void menu() {//game menu code
  image(menu, width/2, height/2, width, height);//menu background
  playerCount.run();//run player count selector
  for(int i = 0; i < playerPerkSelectors.size(); i++) {//run player perk selectors
    playerPerkSelectors.get(i).run();
  }
  livesSelector.run();//run lives selector
  mapSelector.run();//run map selector
  playButton.run();//run play button
  String perkDescription = "";//text for perk being hovered over
  switch(descriptionText) {//set description based on what button was last hovered over
    case "0":
      perkDescription = "Speed Up: increases movement speed of the player";
      break;
    case "1":
      perkDescription = "Triple Jump: gives player an additional jump";
      break;
    case "2":
      perkDescription = "Damage Up: increases damage dealt by the player";
      break;
    case "3":
      perkDescription = "Quick Reload: decreases reload time of all attacks";
      break;
    case "4":
      perkDescription = "Faster Bullets: increases speed of bullets shot by the player";
      break;
    case "5":
      perkDescription = "Extra Ammo: increases the ammo recieved in weapon drops";
      break;
  }
  //menu text
  fill(0);
  textAlign(CENTER);
  textFont(gameFont, sqrt(SFC)*15);
  text(perkDescription, width/2, height/10);//display perk description
  textSize(sqrt(SFC)*30);
  text("Perks:", width/2, height/14);
  text("Lives", 3*width/16, 10*height/15);
  text("Map", 13*width/18, 43*height/72);
  textSize(sqrt(SFC)*20);
  text("Players", 2*width/8, 15*height/18);
  //menu images
  imageMode(CENTER);
  image(mapDisplay, 13*width/18, 9*height/12, sqrt(SFC)*1300/4, sqrt(SFC)*800/4);
  for(int i = 0; i < playerImgCoords.size(); i++) {
    image(playerImgs[i], playerImgCoords.get(i)[0], playerImgCoords.get(i)[1], sqrt(SFC)*150, sqrt(SFC)*150);
    image(controlsImgs[i], playerImgCoords.get(i)[0], playerImgCoords.get(i)[1]+height/6, sqrt(SFC)*150, sqrt(SFC)*150);
  }
  if(mousePressed) mouseIsPressed = true;//set global button reference variable
  else mouseIsPressed = false;
}

void gameStart() {//get current settings, create game, and set gameActive to true
  int players = int(playerCount.selectedButtons.get(0))+2;//get players
  ArrayList<String>[] playerPerkArray = new ArrayList[players];
  for(int i = 0; i < players; i++) {//get player perks
    playerPerkArray[i] = playerPerkSelectors.get(i).selectedButtons;
  }
  int map = int(mapSelector.selectedButtons.get(0)) + 1;//get map
  int lives = int(livesSelector.selectedButtons.get(0)) + 1;//get lives
  game = new Game(map, players, lives, playerPerkArray);//create game
  gameActive = true;//activate game
}

boolean hitBoxOverlap(PVector lowerL1, PVector upperR1, PVector lowerL2, PVector upperR2) {//checks if two rectangles are overlapping based on the lower left point and upper right point of the rectangles
  if (lowerL1.x == upperR1.x || lowerL1.y == upperR1.y || upperR2.x == lowerL2.x || lowerL2.y == upperR2.y) return false;
  if (lowerL1.x > upperR2.x || lowerL2.x > upperR1.x) return false;
  if (upperR1.y > lowerL2.y || upperR2.y > lowerL1.y) return false;
  return true;
}
void generatePerkSelectors(int players, float x, float y, float sizeX, float sizeY) {//generate centered perk selectors based on current player count
  playerPerkSelectors = new ArrayList<Selector>();
  playerImgCoords = new ArrayList<float[]>();
  for(int i = 0; i < players; i++){//calculate coords for each selector
    float posX;
    float posY;
    float spacing = (sizeX+sizeX/4)*perkList.length;
    if(players%2 == 0) posX = (x + (sizeX + spacing)*(i-(players/2-1)) - (sizeX + spacing)/2);
    else posX = x + (sizeX + spacing)*(i-(players-1)/2);
    posY = y;
    playerPerkSelectors.add(new Selector(posX, posY, perkList.length, sizeX, sizeY, 0, 2, true, "perkSelector" + str(i), perkIconList));//create selector at calculated coords
    playerImgCoords.add(new float[] {posX, posY + height/7});//set image coords below selector
  }
}

void buttonEvent(String selector, String button, int type) {//function called when button is turned on, off, or is being hovered over (type = 1, 0, -1)
  if(selector.equals("playerCount") && type > -1) generatePerkSelectors(int(playerCount.getSelectedButtons().get(0))+2, width/2, height/6, SFW*50, SFH*50);//update player perk selectors when player count selector is clicked
  if(selector.equals("") && button.equals("play button") && type > -1) {//start game and deselect play button on press
    gameStart();
    playButton.selected = false;
  }
  if(selector.length() > 11 && selector.substring(0,12).equals("perkSelector") && type == -1) descriptionText = button;//set perk description text if perk selector is being hovered over
  if(type == 1 && selector.equals("mapSelector")) mapDisplay = mapDisplayUpdate(int(button)+1);//update map preview when map selector is clicked on
}

PImage mapDisplayUpdate(int map) {//update map preview image
  switch(map) {
    case 1:
      return mapImgs[0];
    case 2:
      return mapImgs[1];
    case 3:
      return mapImgs[2];
    case 4:
      return mapImgs[3];
    case 5:
      return mapImgs[4];
    case 6:
      return mapImgs[5];
    default:
      return mapImgs[0];
  }
}

void rotator(float posX, float posY, float angle, boolean enable){//used to rotate anything drawn to screen (rotator(desired x position of object,desired x position of object, desired angle, true); <some draw items here at 0,0> rotator(desired x position of object,desired x position of object, desired angle, false);
  if(enable) {
    translate(posX, posY);//"position coords"
    rotate(angle);//"rotation angle"
  } else {
    rotate(-angle);//-"rotation angle"
    translate(-posX, -posY);//-"position coords"
  }
}
void keyPressed() {//run game controls
  if(gameActive) game.controlsPressed();
}

void keyReleased() {//run game controls
  if(gameActive) game.controlsReleased();
}

class Game {
  ArrayList<Projectile> projectiles = new ArrayList<Projectile>();//array list for all projectiles on the map
  ArrayList<Item> items = new ArrayList<Item>();//array list for all items on the map
  ArrayList<GroundPiece> groundPieces = new ArrayList<GroundPiece>();//array list for all ground pieces on the map
  int currentMap;//idex of the current map
  float gravityAcceleration;//game gravity
  float maxSpeed = 150;//maximum physical object speed, see PhysicsObject.speedCheck
  Player[] players;//array of all players
  ArrayList<String>[] playerPerks;//array list of play perks
  int spawnerRate = 500;//how many frames between item spawns
  int spawnerTimer = spawnerRate;//mutable version to use as a clock
  int[] playerLives;//array list for eash players lives
  float[] currentTranslationCoords = new float[]{0,0};//translation coords currently being used
  float currentScaleFactor = 1;//scaling currently being used
  float targetScaleFactor = 1;//scaling factor currentScalingFactor is approaching
  int winSequence;//final clock after winner is decided before game is deactivated
  int winnerIndex = -1;//index of player on player list
  PImage mapBackground;//map background image
  PImage pistol, pistolL, shotgun, shotgunL, uzi, uziL, cannon, cannonL;//weapon images
  
  Game(int map, int playerCount, int lives,  ArrayList<String>[] perksList) {
    gravityAcceleration = SFC*.2;//set game gravity
    mapInfoConstructor();//create map data arrays, see MapInfo
    currentMap = map;//floor(random(1,mapHitBoxInfo.length));//choose random map from list excluding testing map
    mapBackground = loadImage(mapImageInfo[currentMap][0]);//load map background for current map
    createMap(currentMap);//generate ground pieces from chosen map
    playerPerks = perksList;//set play perk lists
    playerConstructor(playerCount);//create player list
    playerLives = new int[players.length];//create player life list
    for(int i = 0; i < playerLives.length; i++) playerLives[i] = lives;//set playerLives to 3
    //load weapon images
    pistol = loadImage("pistol.png");
    pistolL = loadImage("pistolL.png");
    shotgun = loadImage("shotgun.png");
    shotgunL = loadImage("shotgunL.png");
    uzi = loadImage("uzi.png");
    uziL = loadImage("uziL.png");
    cannon = loadImage("cannon.png");
    cannonL = loadImage("cannonL.png");
  }
  
  void run() {
    winCheck();//check if game is won
    
    image(mapBackground,width/2, height/2, width, height);//display background image
    
    scaleFactor();//calculate currentScaleFactor
    scale(currentScaleFactor);//set scale
    translateCoords();//calculate currentTranslationCoords
    translate(currentTranslationCoords[0],currentTranslationCoords[1]);//set translation
    
    runObjects();//run all active game objects
    itemSpawner();//run item spawn
    playerMovement();//use keyboard input for player actions, see PlayerInfo
    
    translate(-currentTranslationCoords[0],-currentTranslationCoords[1]);//revert translation
    scale(1/currentScaleFactor);//revert scaling
    
    gameHUD();//display HUD
    if(winSequence > 0) {
      winSequence--;
      textSize(100);
      textAlign(CENTER);
      fill(playerColors[winnerIndex]);
      text("Winner!", width/2, height/2);
    }
  }
  void winCheck() {
    int a = 0;
    int b = -1;
    for(int i = 0; i < players.length; i++) {//count players with more than 0 lives and record index
      if(playerLives[i] > 0) {
        a++;
        b = i;
      }
    }
    if(a == 1 || winnerIndex != -1) {//if only one player is left
      if(winSequence == 1) gameActive = false;//if final clock is at 1 stop game
      if(winSequence == 0) winSequence = 300;//if final clock is not set, set clock
      if(winnerIndex == -1) winnerIndex = b; //if winner index is not set, set index
    }
  }
  
  void runObjects() {//run all active game objects
    ArrayList<Projectile> projectilesToBeRemoved = new ArrayList<Projectile>();//list for projectiles that need to be removed
    for(Projectile p : projectiles) {//run all projectiles and add ones that need to be removed to remove list
      p.run();
      if(p.toBeRemoved) projectilesToBeRemoved.add(p); 
    }
    
    for(Projectile p : projectilesToBeRemoved) {//remove projectiles on remove list from active list
      projectiles.remove(p);
    }
    
    for(int i = 0; i < players.length; i++) {//run nondead players, repawn players that still have lives
      if(!players[i].isDead) {
        players[i].run();
        if(players[i].toBeRespawned) {//if player is marked for respawn
          playerLives[i]--;//decrement lives
          if(playerLives[i] < 1) players[i].isDead = true;//if out of lives, mark player as dead
          else respawn(i);//if there are still lives respawn player
        }
      }
    }
    
    ArrayList<Item> itemsToBeRemoved = new ArrayList<Item>();//list for items that need to be removed
    for(Item i : items) {//run all items and add ones that need to be removed to remove list
      i.run();
      if(i.toBeRemoved) itemsToBeRemoved.add(i); 
    }
    for(Item i : itemsToBeRemoved) {//remove items on remove list from active list
      items.remove(i);
    }
    noStroke();
    for(GroundPiece g : groundPieces){//render ground pieces
      g.render();
    }
    stroke(0);
  }

  void gameHUD() {//display game HUD
    fill(255);
    textFont(gameFont);
    textSize(sqrt(SFC)*60);
    playerStats(0, LEFT, width/25, 93*height/100);//display player 0 knockback mult and lives
    playerStats(1, RIGHT, 24*width/25, 93*height/100);//display player 1 knockback mult and lives
    if(players.length > 2) playerStats(2, CENTER, width/2, 93*height/100);//display player 2 knockback mult and lives
    
  }
  
  void playerStats(int index, int alignment, float x, float y) {
    textAlign(alignment);
    textSize(60*sqrt(SFC));
    fill(playerColors[index]);
    text(int(players[index].knockBackMult*10*4)/10.0+"x", x, y);//display player knockback mult times 4
    fill(255);
    textSize(20*sqrt(SFC));
    text("Ammo: " + players[index].ammo, x , y - 60*sqrt(SFC));//display player ammo
    
    float size = sqrt(SFC)*20;
    float spacing = size/4;
    float eggXPosition = x;
    float eggYPosition = y+size;
    int direction = 1;
    if(alignment == RIGHT) direction *= -1;//if alignment is RIGHT, switch direction
    if(alignment == CENTER) {//if alignment is CENTER display lives in centered format
      for(int i = 0; i < playerLives[index]; i++){
        if(playerLives[index]%2 == 0) eggXPosition = (x + (size + size/4)*(i-((playerLives[index])/2-1)) - (size + spacing)/2);
        else eggXPosition = x - (size + spacing)*(i-((playerLives[index])-1)/2);
        bezier(eggXPosition-size/2, eggYPosition,  eggXPosition-size/4, eggYPosition-9*size/10,  eggXPosition+size/4, eggYPosition-9*size/10,  eggXPosition+size/2, eggYPosition);
        bezier(eggXPosition-size/2, eggYPosition,  eggXPosition-3*size/4, eggYPosition+9*size/10,  eggXPosition+3*size/4, eggYPosition+9*size/10,  eggXPosition+size/2, eggYPosition);
      }
    } else {//else display lives from direction
      for(int i = 0; i < playerLives[index]; i++) {
        bezier(eggXPosition-size/2, eggYPosition,  eggXPosition-size/4, eggYPosition-9*size/10,  eggXPosition+size/4, eggYPosition-9*size/10,  eggXPosition+size/2, eggYPosition);
        bezier(eggXPosition-size/2, eggYPosition,  eggXPosition-3*size/4, eggYPosition+9*size/10,  eggXPosition+3*size/4, eggYPosition+9*size/10,  eggXPosition+size/2, eggYPosition);
        eggXPosition += direction*(size+spacing);
      }
    }
  }
  
  void itemSpawner() {//spawn item based on spawnerRate
    if(spawnerTimer < 0) {//if timer is 0
      String type;
      int ammo;
      int rand = floor(random(0,100));//choose random int from 0-99
      if(rand < 25) {
        type = "cannon";
        ammo = 5;
      } else if(rand < 50) {
        type = "shotgun";
        ammo = 10;
      } else if(rand < 75) {
        type = "uzi";
        ammo = 100;
      } else {
        type = "pistol";
        ammo = 25;
      }
      rand = floor(random(0,mapSpawnInfo[currentMap][1].length));//choose random item spawn location
      float[] randItemSpawn = mapSpawnInfo[currentMap][1][rand];//store x,y coords of location
      items.add(new Item(randItemSpawn[0],randItemSpawn[1], type, ammo));//spaw item with type and ammo at location coords
      spawnerTimer = spawnerRate + floor(random(-120, 120));//reset timer with +/- 2 seconds
    } else spawnerTimer--;//else decrement timer
  }
  
  void respawn(int i) {//respawn player
    float[][] respawnPoints = mapSpawnInfo[currentMap][0];//get player respawn points from info list
    int randomPoint = floor(random(0,respawnPoints.length));//choose random player respawn point
    players[i] = new Player(respawnPoints[randomPoint][0], respawnPoints[randomPoint][1], playerColors[i], playerPerks[i]);//create new player at respawn point
  }
  
  void scaleFactor() {
    float minX = SFC*1300/2;
    float maxX = SFC*1300/2;
    float minY = SFC*800/2;
    float maxY = SFC*800/2;
    for(Player p : players) {//of all players, find the max and min out of their x and y coords
      if(p.position.y < 9*800*SFC/10) {
        if(p.position.x > maxX) maxX = p.position.x;
        if(p.position.x < minX) minX = p.position.x;
        if(p.position.y > maxY) maxY = p.position.y;
        if(p.position.y < minY) minY = p.position.y;
      }
    }
    float maxDif = Math.max(abs(maxX-minX), abs(maxY-minY));//find the max range of the axis
    if(maxDif == abs(maxX-minX)) {//if x axis has largest range
      maxDif = Math.min(maxDif, 9*SFC*1300/10);//limit to a max of 90% of width
      targetScaleFactor = map(5*maxDif/4, 0, SFC*1300, 2/SFW, .6/SFW);//map the value to a scale of 2-.6
    } else {//if y axis has largest range
      maxDif = Math.min(maxDif, 9*SFC*800/10);//limit range to max of 90% of height
      targetScaleFactor = map(5*maxDif/4, 0, SFC*800, 2/SFH, .6/SFH);//map the value to a scale of 2-.6
    }
    if(winSequence > 0) targetScaleFactor = 2/SFC;
    currentScaleFactor = lerp(currentScaleFactor, targetScaleFactor, 0.05);//interpolate the current scale to the target scale
  }
  
  void translateCoords() {
    float sumX = SFC*1300/2;//add center of level X
    float sumY = SFC*800/2;//add center of level Y
    int playersCounted = 0;
    for(Player p : players) {//for every player that is above 10% of the level, add their x and y to sum x and y
      if(p.position.y < 9*800*SFC/10) {
        sumX += p.position.x;
        sumY += p.position.y;
        playersCounted++;
      }
    }
    float averageX = sumX/(1+playersCounted);//divide sum by players counted + center of level
    float averageY = sumY/(1+playersCounted);//divide sum by players counted + center of level
    float targetTranslationX = (sqrt(SFC)*1300/2/targetScaleFactor)-averageX;
    float targetTranslationY = (sqrt(SFC)*800/2/targetScaleFactor)-averageY;
    if(winSequence > 0) {//if during win sequence, center on player
      targetTranslationX = (sqrt(SFC)*1300/2/targetScaleFactor)-players[winnerIndex].position.x;
      targetTranslationY = (sqrt(SFC)*800/2/targetScaleFactor)-players[winnerIndex].position.y;
    }
    currentTranslationCoords[0] = lerp(currentTranslationCoords[0], targetTranslationX, 0.05);//interpolate current translation to target translation after scale effect
    currentTranslationCoords[1] = lerp(currentTranslationCoords[1], targetTranslationY, 0.05);//interpolate current translation to target translation after scale effect
  }
  
  void createMap(int currentMap) {//create ground pieces from mapHitBoxInfo, see MapInfo
    for(float[] hitboxInfo : mapHitBoxInfo[currentMap]) {//for every hitbox in current map
      groundPieces.add(new GroundPiece(hitboxInfo));//create ground piece using its hitbox info
    }
  }

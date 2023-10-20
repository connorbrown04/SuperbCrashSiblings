color[] playerColors = new color[]{color(255,0,0),color(0,0,255),color(0,255,0)};//player colors
boolean p0U=false, p0L=false, p0D=false, p0R=false, p0A=false, p1U=false, p1L=false, p1D=false, p1R=false, p1A=false, p2U=false, p2L=false, p2D=false, p2R=false, p2A=false;//held button variables (U: up, L: left, D: down, A: attack)

void playerMovement() {//when the button is pressed down, the player moves and the direction it is facing changes, also initiates walking animation
  if(p0U) {players[0].directionChange('y', -1); if(!p0L && !p0R) players[0].directionChange('x', 0);}
  if(p0L) {players[0].movementLR(false); players[0].walking = true;}
  if(p0D) {players[0].directionChange('y', 1); if(!p0L && !p0R) players[0].directionChange('x', 0);}
  if(p0R) {players[0].movementLR(true); players[0].walking = true;}
  if(p0A) players[0].attack();
  if(p1U) {players[1].directionChange('y', -1); if(!p1L && !p1R) players[1].directionChange('x', 0);}
  if(p1L) {players[1].movementLR(false); players[1].walking = true;}
  if(p1D) {players[1].directionChange('y', 1);if(!p1L && !p1R) players[1].directionChange('x', 0);}
  if(p1R) {players[1].movementLR(true); players[1].walking = true;}
  if(p1A) players[1].attack();
  if(players.length > 2) {
    if(p2U) {players[2].directionChange('y', -1); if(!p2L && !p2R) players[2].directionChange('x', 0);}
    if(p2L) {players[2].movementLR(false); players[2].walking = true;}
    if(p2D) {players[2].directionChange('y', 1);if(!p2L && !p2R) players[2].directionChange('x', 0);}
    if(p2R) {players[2].movementLR(true); players[2].walking = true;}
    if(p2A) players[2].attack();
  }
}

void controlsReleased() {//when the button is released, movement and animations end
  if(key == 'w') {p0U = false; players[0].directionChange('y', 0);}
  if(key == 'a') {p0L = false; players[0].directionChange('x', 0); players[0].walking = false;}
  if(key == 's') {players[0].crouch(false); players[0].directionChange('y', 0); p0D = false;}
  if(key == 'd') {p0R = false; players[0].directionChange('x', 0); players[0].walking = false;}
  if(key == 'q') p0A = false;
  if(key == 'i') {p1U = false; players[1].directionChange('y', 0);}
  if(key == 'j') {p1L = false; players[1].directionChange('x', 0); players[1].walking = false;}
  if(key == 'k') {players[1].crouch(false); players[1].directionChange('y', 0); p1D = false;}
  if(key == 'l') {p1R = false; players[1].directionChange('x', 0); players[1].walking = false;}
  if(key == 'o') p1A = false;
  if(players.length > 2) {
    if(key == 't') {p2U = false; players[2].directionChange('y', 0);}
    if(key == 'f') {p2L = false; players[2].directionChange('x', 0); players[2].walking = false;}
    if(key == 'g') {players[2].crouch(false); players[2].directionChange('y', 0); p2D = false;}
    if(key == 'h') {p2R = false; players[2].directionChange('x', 0); players[2].walking = false;}
    if(key == 'y') p2A = false;
  }
}

void controlsPressed() {//recognizes when the key is pressed, starting the above statements and changing directions
  if(key == 'w') {
    players[0].jump();
    if(!p0L && !p0R) players[0].directionChange('x', 0);
    players[0].directionChange('y', -1);
    p0U = true;
  }
  if(key == 's') {
    if(!p0L && !p0R) players[0].directionChange('x', 0);
    players[0].directionChange('y', 1);
    players[0].crouch(true);
    p0D = true;
  }
  if(key == 'i') {
    players[1].jump();
    if(!p1L && ! p1R) players[1].directionChange('x', 0);
    players[1].directionChange('y', -1);
    p1U = true;
  }
  if(key == 'k') {
    if(!p1L && !p1R) players[1].directionChange('x', 0);
    players[1].directionChange('y', 1);
    players[1].crouch(true);
    p1D = true;
  }
  if(players.length > 2) {
    if(key == 't') {
      players[2].jump();
      if(!p2L && ! p2R) players[2].directionChange('x', 0);
      players[2].directionChange('y', -1);
      p2U = true;
    }
    if(key == 'g') {
      if(!p2L && !p2R) players[2].directionChange('x', 0);
      players[2].directionChange('y', 1);
      players[2].crouch(true);
      p2D = true;
    }
  }
  if(key == 'a') p0L = true;
  if(key == 'd') p0R = true;
  if(key == 'q') p0A = true;
  if(key == 'j') p1L = true;
  if(key == 'l') p1R = true;
  if(key == 'o') p1A = true;
  if(key == 'f') p2L = true;
  if(key == 'h') p2R = true;
  if(key == 'y') p2A = true;
}

void playerConstructor(int count) {
  float[][] playerSpawnPointList = mapSpawnInfo[currentMap][0];//get possible spawnPoints
  players = new Player[count];//create player array
  for(int i = 0; i < count; i++) {//add players to list based on perk list
    players[i] = new Player(playerSpawnPointList[i][0], playerSpawnPointList[i][1], playerColors[i], playerPerks[i]);
  }
}


class Player extends PhysicsObject {
  String weapon = "unarmed";//current weapon of player
  int ammo = 0;//ammo 
  float ammoMult = 1;//ammo multiplier for perk
  float speedMult = 1;//speed multiplier for perk
  float damageMult = 1;//damage multiplier for perk
  float reloadMult = 1;//reload speed multiplier for perk
  float bulletSpeedMult = 1;//bullet speed multiplier for perk
  color playerColor;// color of player from playerColors
  PVector direction = new PVector(1, 0);//direction player is facing
  float savedXDirection;//variable for the last x direction player was facing before looking up/down
  float knockBackMult = .25;//knockback multiplier used whenever player is hit
  int maxJumps = 2;//max jumps of the player
  int totalJumps = maxJumps;//jumps player has left
  int attackCoolDown = 0;//timer before player can attack again
  boolean toBeRespawned = false;//whether player needs to be respawned
  boolean isDead = false;//whether player will not be respawned
  int invincibleFrames = 120;//initial invinciblility frames
  boolean crouched = false;//contols whether is is crouching
  boolean walking = false; //whether the walking animation is happening
  boolean jump = false; //whether the jump animation starts
  float eyeAngle = 0; //the angle that the eye is looking at 
  int foot1Angle = 90; //angle of the first foot
  int foot2Angle = 90;//angle of the second foot
  boolean forward = true;//whether the first foot is moving forward
  boolean backward = false; //whether the first foot is moving backward
  boolean forward2 = false;//whether the second foot is moving forward
  boolean backward2 = true;//whether the second foot is moving backward
  float arm = 1; //how long the arm punch animation has been occuring
  boolean armMove = false; //whether the arm is moving
  float armIncrease = 0; //the amount  that the arm position is increasing by when punching
  int jLength = 0; //how long the jump animation has been occurring


  Player(float x, float y, color playerColor, ArrayList<String> perks) {
    super(x, y, SFC*25, SFC*50);//set position and size
    lowerL = new PVector(position.x-size.x/2, position.y+size.y/2);//calculate lower left point of hitbox
    upperR = new PVector(position.x+size.x/2, position.y-size.y/2);//calculate upper right point of hitbox
    this.playerColor = playerColor;//set player color
    for (String perk : perks) {//activate any perks in perk list
      switch(int(perk)) {
      case 0:
        speedMult = 1.5;
        break;
      case 1:
        maxJumps = 3;
        break;
      case 2:
        damageMult = 1.5;
        break;
      case 3:
        reloadMult = .5;
        break;
      case 4:
        bulletSpeedMult = 2;
        break;
      case 5:
        ammoMult = 1.5;
        break;
      }
    }
  }
  void run() {
    update();//update physicas
    updatePlayer();//player specific updates
    render();//render player
  }
  void crouch(boolean isCrouching) {//changes size of player and hitbox
    if (isCrouching) {
      size.set(SFC*25, SFC*37);//if crouching set height to 3/4
      position.set(position.x, position.y+SFC*6);
    } else size.set(SFC*25, SFC*50);//else set height to default
  }
  void updatePlayer() {//player specific updates
    if (invincibleFrames > 0) invincibleFrames--;//decrement invincibility frames
    if (grounded && abs(velocity.y) < .2) totalJumps = maxJumps;//if grounded and not moving regen jumps
    if (attackCoolDown > 0) attackCoolDown--;//decrement attackCoolDown
    if (position.y - size.y > SFC*1000) toBeRespawned = true;//if player is below 5/4 of height, respawn player
    if (position.y < SFC*-2000) toBeRespawned = true;
    if (ammo < 1 && !weapon.equals("unarmed")) {//if out of ammo and not unarmed
      weapon = "unarmed";//set weapon to unarmed
    }
    float minDist = Integer.MAX_VALUE;
    for (Player p : players) {//calculate angle of pupil based on closest player
      if (p != this && minDist > sqrt(pow(p.position.x-position.x, 2) + pow(p.position.y-position.y, 2))) {
        minDist = sqrt(pow(p.position.x-position.x, 2) + pow(p.position.y-position.y, 2));
        eyeAngle = atan2(p.position.y-position.y, p.position.x-position.x);
      }
    }
  }
  void render() {//render player
    float h = size.y*1.2;
    float w = size.x*1.2;
    float top = w/15;
    float eyeChange = -0.7;
    float footChangeOne = -w/50;
    float footChangeTwo = w/5;
    float x = position.x;
    float y = position.y+2.5;
    float armX = x;
    float armY = y;

    //controls whether walk animation is occurring and does not occur if it is jumping
    if ((direction.x == 1 || direction.x == -1)&& jump == false);
    else if (jump == false) {
      foot1Angle = 90;
      foot2Angle = 90;
    }
    
    //shrinks the player if it is crouched
    if (crouched) h = 3*h/4;
    
    //if the player is facing right, then the head, eyes and feet are in the right direction
    if (direction.x == 1 || (direction.x == 0 && savedXDirection == 1)) {
      top = w/15;
      eyeChange = -0.7;
      footChangeOne = -w/50;
      footChangeTwo = w/5;
    }
    
    //if the player is facing left, then the head, eyes and feet are in the left direction
    if ((direction.x == -1)||(direction.x == 0 && savedXDirection == -1)) {
      top = -w/15;
      eyeChange = 0.7;
      footChangeOne = w/50;
      footChangeTwo = -w/5;

      if (direction.y == 0 && (direction.x == 0 && savedXDirection == -1)) {
        direction.x = -1;
      }
    }

    //feet
    rectMode(CORNER);
    noStroke();
    fill(0);
    fill(255, 0, 0);

   
    //changes the angle of foot one when it is walking
    if ((direction.x==1 || direction.x ==-1) && (jump == false) && (walking)) {
      if (forward) {
        foot1Angle -= 4;
        if (foot1Angle <= 45) {
          forward = false;
          backward = true;
        }
      }
      if (backward) {
        foot1Angle += 4;
        if (foot1Angle >= 135) {
          backward = false;
          forward = true;
        }
      }
    }


    //changes the angle of foot two when it is walking
    if ((direction.x==1 || direction.x ==-1) && (jump == false) && (walking)) {
      if (forward2) {
        foot2Angle -= 4;
        if (foot2Angle <= 45) {
          forward2 = false;
          backward2 = true;
        }
      }
      if (backward2) {
        foot2Angle += 4;
        if (foot2Angle >= 135) {
          backward2 = false;
          forward2 = true;
        }
      }
    }
    
    if(walking == false && jump == false){
      foot1Angle = 90;
      forward = true;
      backward = false;
      foot2Angle = 90;
      forward2 = false;
      backward2 = true;
    }

    //controls the feet when it is in the jump animation
    if (jLength == 50) { //when jLength has reached 50, the jump animation is over
      jump = false;
      jLength = 0;
    }
    //increases the value of jLength and moves the feet into the jump animation 
    if (jump == true) {
      jLength ++;
      if (foot1Angle > 30) foot1Angle -=3;
      if (foot2Angle < 150) foot2Angle +=3;
    }
    //the coordinates for the quads that make the first feet to be drawn with it rotating
    float oneX = (w/2)*cos(radians(foot1Angle))+x + (sin(radians(foot1Angle))*-w/50);
    float oneY = (h/4)*sin(radians(foot1Angle))+y + (cos(radians(foot1Angle))*w/50);
    float twoX = (w/2)*cos(radians(foot1Angle))+x + (sin(radians(foot1Angle))*w/50);
    float twoY = (h/4)*sin(radians(foot1Angle))+y + (cos(radians(foot1Angle))*-w/50);
    float threeX = (w/2+w/4)*cos(radians(foot1Angle))+x + (sin(radians(foot1Angle))*-w/50);
    float threeY = (h/4+h/8)*sin(radians(foot1Angle))+y + (cos(radians(foot1Angle))*w/50);
    float fourX = (w/2+w/4)*cos(radians(foot1Angle))+x + (sin(radians(foot1Angle))*w/50);
    float fourY = (h/4+h/8)*sin(radians(foot1Angle))+y + (cos(radians(foot1Angle))*-w/50);
    float fiveX = (w/2+w/4-w/25)*cos(radians(foot1Angle))+x + (sin(radians(foot1Angle))*-w/50);
    float fiveY = (h/4+h/8-h/50)*sin(radians(foot1Angle))+y + (cos(radians(foot1Angle))*w/50);
    float sevenX = (w/2+w/4)*cos(radians(foot1Angle))+x + (sin(radians(foot1Angle))*(footChangeOne+footChangeTwo));
    float sevenY = (h/4+h/8)*sin(radians(foot1Angle))+y + (cos(radians(foot1Angle))*-(footChangeOne+footChangeTwo));
    float eightX = (w/2+w/4-w/25)*cos(radians(foot1Angle))+x + (sin(radians(foot1Angle))*(footChangeOne+footChangeTwo));
    float eightY = (h/4+h/8-h/50)*sin(radians(foot1Angle))+y + (cos(radians(foot1Angle))*-(footChangeOne+footChangeTwo));

    //draws the first foot
    fill(0);
    quad(oneX, oneY, twoX, twoY, fourX, fourY, threeX, threeY);
    quad(threeX, threeY, sevenX, sevenY, eightX, eightY, fiveX, fiveY);

    //the coordinates for the quads that make the second feet to be drawn with it rotating
    float oneX2 = (w/2)*cos(radians(foot2Angle))+x + (sin(radians(foot2Angle))*-w/50);
    float oneY2 = (h/4)*sin(radians(foot2Angle))+y + (cos(radians(foot2Angle))*w/50);
    float twoX2 = (w/2)*cos(radians(foot2Angle))+x + (sin(radians(foot2Angle))*w/50);
    float twoY2 = (h/4)*sin(radians(foot2Angle))+y + (cos(radians(foot2Angle))*-w/50);
    float threeX2 = (w/2+w/4)*cos(radians(foot2Angle))+x + (sin(radians(foot2Angle))*-w/50);
    float threeY2 = (h/4+h/8)*sin(radians(foot2Angle))+y + (cos(radians(foot2Angle))*w/50);
    float fourX2 = (w/2+w/4)*cos(radians(foot2Angle))+x + (sin(radians(foot2Angle))*w/50);
    float fourY2 = (h/4+h/8)*sin(radians(foot2Angle))+y + (cos(radians(foot2Angle))*-w/50);
    float fiveX2 = (w/2+w/4-w/25)*cos(radians(foot2Angle))+x + (sin(radians(foot2Angle))*-w/50);
    float fiveY2 = (h/4+h/8-h/50)*sin(radians(foot2Angle))+y + (cos(radians(foot2Angle))*w/50);
    float sevenX2 = (w/2+w/4)*cos(radians(foot2Angle))+x + (sin(radians(foot2Angle))*(footChangeOne+footChangeTwo));
    float sevenY2 = (h/4+h/8)*sin(radians(foot2Angle))+y + (cos(radians(foot2Angle))*-(footChangeOne+footChangeTwo));
    float eightX2 = (w/2+w/4-w/25)*cos(radians(foot2Angle))+x + (sin(radians(foot2Angle))*(footChangeOne+footChangeTwo));
    float eightY2 = (h/4+h/8-h/50)*sin(radians(foot2Angle))+y + (cos(radians(foot2Angle))*-(footChangeOne+footChangeTwo));


    //draws the second foot
    fill(0);
    quad(oneX2, oneY2, twoX2, twoY2, fourX2, fourY2, threeX2, threeY2);
    quad(threeX2, threeY2, sevenX2, sevenY2, eightX2, eightY2, fiveX2, fiveY2);

    //the fololowing code draws the two circles compromisign the top and bottom of the player
    stroke(1);
    strokeWeight(w/12.5);
    //these ellipses make the dark outline of the duck
    fill(0, 0);
    ellipse(x+top, y-h/4, w/1.2, h/2.4);
    ellipse(x, y, w, h/2);
    //this creates the bottom ellipse of the duck
    fill(playerColor);
    noStroke();
    ellipse(x, y, w, h/2);
    //this makes the top ellipse of the duck
    fill(playerColor);
    stroke(1);
    strokeWeight(w/250);
    ellipse(x+top, y-h/4, w/1.2, h/2.4);

    //draws the eye on the duck based on the direction it is phasing
    float angle = (atan2(direction.y, direction.x))+eyeChange; //the position of the eye rotates based on where the head is looking
    float eyeX = (h/10.2)*cos(angle)+(x+top);//the x position of the center of the eye
    float eyeY = (h/10.2)*sin(angle)+(y-h/4);//the y position of the center of the eye
    //draws the white of the eye
    fill(255);
    ellipse(eyeX, eyeY, w/3.8, h/7.6);
    stroke(0);
    strokeWeight(w/35.7);
    //draws the outline of the eye
    fill(0, 0);
    ellipse(eyeX, eyeY, w/3.5, h/7);
    //draws the pupil which rotates based on eyeAngle to look at the nearest player
    float pupilX = (w/14)*cos(eyeAngle)+(eyeX);
    float pupilY = (h/28)*sin(eyeAngle)+(eyeY);
    fill(0);
    noStroke();
    ellipse(pupilX, pupilY, w/7, h/14);

    //rotates the points for the beak of the eye depending on the way the bird is facing
    float b1Angle = (atan2(direction.y, direction.x))+0.2;
    float b1X = (w/2.3)*cos(b1Angle)+(x+top);
    float b1Y = (h/4.6)*sin(b1Angle)+(y-h/4);
    float b2Angle = (atan2(direction.y, direction.x))-0.2;
    float b2X = (w/2.3)*cos(b2Angle)+(x+top);
    float b2Y = (h/4.6)*sin(b2Angle)+(y-h/4);
    float b3Angle = (atan2(direction.y, direction.x));
    float b3X = (w/2.3+w/4)*cos(b3Angle)+(x+top);
    float b3Y = (h/4.6+h/8)*sin(b3Angle)+(y-h/4);
    //draws the beak
    fill(255, 255, 51);
    stroke(0);
    triangle(b1X, b1Y, b2X, b2Y, b3X, b3Y);


    //controls the movement of the arms when it is unarmed and punching
    //the rate that it moves increaeses with each frame to give a sharper movement
    if (armMove == true) {
      //if it is facing right, the x position of the arm slides to the right to punch
      if (((direction.x == 1 || (direction.x == 0 && savedXDirection == 1))&& direction.y == 0)) {
        if (arm<5) armIncrease += w/7;
        if (arm>5) armIncrease -=  w/7;
        armX += armIncrease;
        arm++;
      }
      //if it is facing left, the x position of the arm slides to the left to punch
      if (((direction.x == -1 || (direction.x == 0 && savedXDirection == -1))&& direction.y == 0)) {
        if (arm<5) armIncrease -=  w/7;
        if (arm>5) armIncrease +=  w/7;
        armX += armIncrease;
        arm++;
      }
      //if it is facing up, the y position of the arm slides up to punch
      if (direction.y == -1) {
        if (arm<5) armIncrease -=  h/10;
        if (arm>5) armIncrease +=  h/10;
        armY += armIncrease;
        arm++;
      }
      //if it is facing down, the x position of the arm slides down to punch
      if (direction.y == 1) {
        if (arm<5) armIncrease +=  h/10;
        if (arm>5) armIncrease -=  h/10;
        armY += armIncrease;
        arm++;
      }
      
      //once the arm has done the punch animation, it resets the arm's position and arm Increase
      if (arm == 9) {
        arm = 1;
        armMove = false;
        armX = x;
        armY = y;
        armIncrease = 0;
      }
    }
    imageMode(CENTER);
    //the following if statements draws the arms with the weapons if the have them.
    //draws the right arm facing directly right
    if (((direction.x == 1 || (direction.x == 0 && savedXDirection == 1))&& direction.y == 0)) {
      rotator(armX+w/2.5, armY+h/22, 0, true);//rotates the screen
      if(weapon.equals("pistol")) image(pistol, 0, 0, w, h/2.5);//draws the weapon
      if(weapon.equals("uzi")) image(uzi, 0, 0, w*2, h/1.75);
      if(weapon.equals("shotgun")) image(shotgun, 0, 0, w*1.5, h/1.5);
      if(weapon.equals("cannon")) image(cannon, 0, 0, w*1.4, h/2.2);
      rotator(armX+w/2.5, armY+h/22, 0, false);//unrotates the screen leaving the weapon rotated
      //rotator(float posX, float posY, float angle, boolean enable)
      fill(playerColor);
      noStroke();
      ellipse(armX+w/2.85, y+h/14, w/6, h/12);//fills inside of arms
      ellipse(armX-w/25, y+h/32, w/5.5, h/8);
      ellipse(armX+w/5.5, y+h/14, w/2.5, h/11);
      stroke(0);
      strokeWeight(3*w/75);
      arc(armX, y+h/32, w/4, h/6, PI/2.5, 3*PI/2.4);//draws outline of the arm
      arc(armX-w/16, y+h/32, w/4, h/7, -PI/3, PI/6);
      arc(armX+w/5.5, y+h/16, w/3, h/12, 3*PI/2.4, 3*PI/1.7);
      arc(armX+w/6, y+h/13, w/2.5, h/12, PI/4, PI/1.2);
      arc(armX+w/2.85, y+h/14, w/6, h/11, -PI/1.5, PI/1.5);
    }
    //draws the left arm facing directly left
    if (((direction.x == -1 || (direction.x == 0 && savedXDirection == -1))&& direction.y == 0)) {
      rotator(armX-w/2.5, armY+h/22, 0, true);
      if(weapon.equals("pistol")) image(pistolL, 0, 0, w, h/2.5);//draws the weapon
      if(weapon.equals("uzi")) image(uziL, 0, 0, w*2, h/1.75);
      if(weapon.equals("shotgun")) image(shotgunL, 0, 0, w*1.5, h/1.5);
      if(weapon.equals("cannon")) image(cannonL, 0, 0, w*1.4, h/2.2);
      rotator(armX-w/2.5, armY+h/22, 0, false);
      fill(playerColor);
      noStroke();
      ellipse(armX-w/2.85, y+h/14, w/6, h/12);
      ellipse(armX+w/25, y+h/32, w/5.5, h/8);
      ellipse(armX-w/5.5, y+h/14, w/2.5, h/11);
      stroke(0);
      strokeWeight(3*w/75);
      arc(armX, y+h/32, w/4, h/6, -PI/4, PI/2+PI/10);
      arc(armX+w/16, y+h/32, w/4, h/7, PI-PI/6, PI+PI/3);
      arc(armX-w/5.5, y+h/16, w/3, h/12, PI+.4*PI/1.7, 3*PI/2+PI/4);
      arc(armX-w/6, y+h/13, w/2.5, h/12, PI/6, 3*PI/4);
      arc(armX-w/2.85, y+h/14, w/6, h/11, PI/3, 3*PI/2+PI/6);
    }

    //draws the right arm facing directly up
    if (((savedXDirection == 1 && direction.y == -1) || (savedXDirection == 0 && direction.y == -1)) && (walking == false || weapon == "unarmed")) {
      rotator(armX-w/16, armY-h/2.8, -PI/2, true);
      if(weapon.equals("pistol")) image(pistol, 0, 0, w, h/2.5);//draws the weapon
      if(weapon.equals("uzi")) image(uzi, 0, 0, w*2, h/1.75);
      if(weapon.equals("shotgun")) image(shotgun, 0, 0, w*1.5, h/1.5);
      if(weapon.equals("cannon")) image(cannon, 0, 0, w*1.4, h/2.2);
      rotator(armX-w/16, armY-h/2.8, -PI/2, false);
      noStroke();
      fill(playerColor);
      ellipse(armX-w/32, armY-h/16, w/5.5, h/6.5);
      ellipse(armX-w/30, armY-h/4.8, w/6, h/5);
      ellipse(armX-w/30, armY-h/3.2, w/5.5, h/12);
      stroke(0);
      strokeWeight(3*w/75);
      arc(armX-w/16, armY-h/16, w/8, h/7, PI/1.8, 3*PI/2.2);
      arc(armX, armY-h/16, w/7, h/7, -PI/3, PI/2.2);
      arc(armX-w/14, armY-h/4.8, w/11, h/6, PI/1.8, 3*PI/2.2);
      arc(armX, armY-h/5, w/7, h/5.8, -PI/2.7, PI/2.2);
      arc(armX-w/30, armY-h/3.2, w/5.5, h/12, -3*PI/2.4, PI/3.7);
    }

    //draws the left arm facing directly up
    if (savedXDirection == -1 && direction.y == -1 && (walking == false || weapon == "unarmed")) {
      rotator(armX+w/16, armY-h/2.8, PI/2, true);
      if(weapon.equals("pistol")) image(pistolL, 0, 0, w, h/2.5);//draws the weapon
      if(weapon.equals("uzi")) image(uziL, 0, 0, w*2, h/1.75);
      if(weapon.equals("shotgun")) image(shotgunL, 0, 0, w*1.5, h/1.5);
      if(weapon.equals("cannon")) image(cannonL, 0, 0, w*1.4, h/2.2);
      rotator(armX+w/16, armY-h/2.8, PI/2, false);
      noStroke();
      fill(playerColor);
      ellipse(armX+w/32, armY-h/16, w/5.5, h/6.5);
      ellipse(armX+w/30, armY-h/4.8, w/6, h/5);
      ellipse(armX+w/30, armY-h/3.2, w/5.5, h/12);
      stroke(0);
      strokeWeight(3*w/75);
      arc(armX+w/16, armY-h/16, w/8, h/7, -0.8*PI/2.2, 0.8*PI/1.8);
      arc(armX, armY-h/16, w/7, h/7, 1.2*PI/2.2, 4*PI/3);
      arc(armX+w/14, armY-h/4.8, w/11, h/6, -0.8*PI/2.2, 0.8*PI/1.8);
      arc(armX, armY-h/5, w/7, h/5.8, 1.2*PI/2.2, 3.7*PI/2.7);
      arc(armX+w/30, armY-h/3.2, w/5.5, h/12, -4.7*PI/3.7, 0.6*PI/2.4);
    }

    //draws the right arm facing directly down
    if (savedXDirection == 1 && direction.y == 1 && (walking == false || weapon == "unarmed")) {
      rotator(armX, armY+h/2.8, PI/2, true);
      if(weapon.equals("pistol")) image(pistol, 0, 0, w, 50*h/92.5);//draws the weapon
      if(weapon.equals("uzi")) image(uzi, 0, 0, w*2, 50*h/64.75);
      if(weapon.equals("shotgun")) image(shotgun, 0, 0, w*1.5, 50*h/55.5);
      if(weapon.equals("cannon")) image(cannon, 0, 0, w*1.4, 50*h/74);
      rotator(armX, armY+h/2.8, PI/2, false);
      noStroke();
      fill(playerColor);
      ellipse(armX-w/32, armY+h/16, w/5.5, h/6.5);
      ellipse(armX-w/30, armY+h/4.8, w/6, h/5);
      ellipse(armX-w/30, armY+h/3.2, w/5.5, h/12);
      stroke(0);
      strokeWeight(3*w/75);
      arc(armX-w/16, armY+h/16, w/8, h/7, 0.6*PI/4.4 + PI/2, 3*PI/2 - 0.2*PI/3.6);
      arc(armX, armY+h/16, w/7, h/7, -PI/2.2, PI/3);
      arc(armX-w/14, armY+h/4.8, w/11, h/6, 0.6*PI/4.4 + PI/2, 3*PI/2 - 0.2*PI/3.6);
      arc(armX, armY+h/5, w/7, h/5.8, -PI/2.2, PI/2.7);
      arc(armX-w/30, armY+h/3.2, w/5.5, h/12, -PI/3.7, 3*PI/2.4);
    }

    //draws the left arm facing directly down
    if (savedXDirection == -1 && direction.y == 1 && (walking == false || weapon == "unarmed")) {
      rotator(armX, armY+h/2.8, -PI/2, true);
      if(weapon.equals("pistol")) image(pistolL, 0, 0, w, 50*h/92.5);//draws the weapon
      if(weapon.equals("uzi")) image(uziL, 0, 0, w*2, 50*h/64.75);
      if(weapon.equals("shotgun")) image(shotgunL, 0, 0, w*1.5, 50*h/55.5);
      if(weapon.equals("cannon")) image(cannonL, 0, 0, w*1.4, 50*h/74);
      rotator(armX, armY+h/2.8, -PI/2, false);
      noStroke();
      fill(playerColor);
      ellipse(armX+w/32, armY+h/16, w/5.5, h/6.5);
      ellipse(armX+w/30, armY+h/4.8, w/6, h/5);
      ellipse(armX+w/30, armY+h/3.2, w/5.5, h/12);
      stroke(0);
      strokeWeight(3*w/75);
      arc(armX+w/16, armY+h/16, w/8, h/7, -0.8*PI/1.8, 0.8*PI/2.2);
      arc(armX, armY+h/16, w/7, h/7, -4*PI/3, -1.2*PI/2.2);
      arc(armX+w/14, armY+h/4.8, w/11, h/6, -0.8*PI/1.8, 0.8*PI/2.2);
      arc(armX, armY+h/5, w/7, h/5.8, -3.7*PI/2.7, -1.2*PI/2.2);
      arc(armX+w/30, armY+h/3.2, w/5.5, h/12, -0.6*PI/2.4, 4.7*PI/3.7);
    }

    //draws the right arm facing diagonally up right
    if (direction.x == 1 && direction.y == -1 && walking && weapon != "unarmed") {
      rotator(armX+w/2.5, armY-h/3.6, -PI/4, true);
      if(weapon.equals("pistol")) image(pistol, 0, 0, w, h/2.5);//draws the weapon
      if(weapon.equals("uzi")) image(uzi, 0, 0, w*2, h/1.75);
      if(weapon.equals("shotgun")) image(shotgun, 0, 0, w*1.5, h/1.5);
      if(weapon.equals("cannon")) image(cannon, 0, 0, w*1.4, h/2.2);
      rotator(armX+w/2.5, armY-h/3.6, -PI/4, false);
      noStroke();
      fill(playerColor);
      quad(armX-w/4.8, armY-h/26, armX-w/10, armY+h/34, armX+w/7, armY-h/11, armX+w/30, armY-h/7.5);
      quad(armX+w/30, armY-h/7.5, armX+w/7, armY-h/11, armX+w/2.4, armY-h/4, armX+w/4, armY-h/4);
      stroke(0);
      strokeWeight(3);
      arc(armX+w/50, armY+w/12, w/2, h/3, 3*PI/2.6, 3*PI/2, OPEN);
      arc(armX-w/10, armY-h/8.5, w/2, h/3.5, PI/20, PI/2, OPEN);
      arc(armX+w/3, armY-h/18, w/1.5, h/2.5, 3*PI/2.7, 3*PI/2.1, OPEN);
      arc(armX+w/21, armY-h/3.5, w/1.5, h/2.5, PI/8, PI/2.2, OPEN);
      arc(armX+w/2.8, armY-h/4, w/5.5, h/12, -3*PI/2.4+PI/4, PI/3.7+PI/4, OPEN);
    }

    //draws the right arm facing diagonally down right
    if (direction.x == 1 && direction.y == 1 && walking && weapon != "unarmed") {
      rotator(armX+w/4, armY+h/4.5, PI/4, true);
      if(weapon.equals("pistol")) image(pistol, 0, 0, w, 50*h/92.5);//draws the weapon
      if(weapon.equals("uzi")) image(uzi, 0, 0, w*2, 50*h/64.75);
      if(weapon.equals("shotgun")) image(shotgun, 0, 0, w*1.5, 50*h/55.5);
      if(weapon.equals("cannon")) image(cannon, 0, 0, w*1.4, 50*h/74);
      rotator(armX+w/4, armY+h/4.5, PI/4, false);
      noStroke();
      fill(playerColor);
      quad(armX-w/3.2, armY-h/9.5, armX-w/9.6, armY+h/30, armX, armY, armX-w/6.8, armY-h/6);
      quad(armX-w/13, armY+h/40, armX+w/7, armY+h/5, armX+w/4.9, armY+h/7.6, armX-w/30, armY-h/30);
      stroke(0, 0, 0);
      strokeWeight(3);
      arc(armX-w/9.5-w/6, armY+h/16-h/12, w/2, h/3, 3*PI/2.6+PI/2, 3*PI/2+PI/2, OPEN);
      arc(armX+w/9-w/6, armY-h/40-h/12, w/2, h/3.5, PI/20+PI/2, PI, OPEN);
      arc(armX+w/31-w/6, armY+h/4-h/12, w/1.5, h/2.5, 3*PI/2.7+PI/2, 3*PI/2.1+PI/2, OPEN);
      arc(armX+w/2.55-w/6, armY+h/17-h/12, w/1.5, h/2.5, PI/8+PI/2, PI/2.2+PI/2, OPEN);
      arc(armX+w/2.8-w/6, armY+h/4-h/12, w/5.5, h/12, -3*PI/2.4+3*PI/4, PI/3.7+3*PI/4, OPEN);
    }

    //draws the left arm facing diagonally up left
    if (direction.x == -1 && direction.y == -1 && walking && weapon != "unarmed") {
      rotator(armX-w/2.5, armY-h/3.6, PI/4, true);
      if(weapon.equals("pistol")) image(pistolL, 0, 0, w, h/2.5);//draws the weapon
      if(weapon.equals("uzi")) image(uziL, 0, 0, w*2, h/1.75);
      if(weapon.equals("shotgun")) image(shotgunL, 0, 0, w*1.5, h/1.5);
      if(weapon.equals("cannon")) image(cannonL, 0, 0, w*1.4, h/2.2);
      rotator(armX-w/2.5, armY-h/3.6, PI/4, false);
      noStroke();
      fill(playerColor);
      quad(armX-w/2.3, armY-h/4, armX-w/9, armY-h/15, armX-w/45, armY-h/8, armX-w/3.5, armY-h/3.8);
      quad(armX-w/10, armY-h/14, armX+w/10, armY+h/37, armX+w/5, armY-h/26, armX-w/20, armY-h/7);
      stroke(0);
      strokeWeight(3);
      arc(armX-w/50, armY+w/12, w/2, h/3, 3*PI/2, 4.8*PI/2.6, OPEN);
      arc(armX+w/10, armY-h/8.5, w/2, h/3.5, PI/2, PI-(PI/20), OPEN);
      arc(armX-w/3, armY-h/18, w/1.5, h/2.5, -0.9*PI/2.1, -PI/9, OPEN);
      arc(armX-w/21, armY-h/3.5, w/1.5, h/2.5, PI-(PI/2.2), PI-(PI/8), OPEN);
      arc(armX-w/2.8, armY-h/4, w/5.5, h/12, -3*PI/2.4-PI/4, PI/3.7-PI/4, OPEN);
    }

    //draws the left arm facing diagonally down left
    if (direction.x == -1 && direction.y == 1 && walking && weapon != "unarmed") {
      rotator(armX-w/4, armY+h/4.5, -PI/4, true);
      if(weapon.equals("pistol")) image(pistolL, 0, 0, w, 50*h/92.5);//draws the weapon
      if(weapon.equals("uzi")) image(uziL, 0, 0, w*2, 50*h/64.75);
      if(weapon.equals("shotgun")) image(shotgunL, 0, 0, w*1.5, 50*h/55.5);
      if(weapon.equals("cannon")) image(cannonL, 0, 0, w*1.4, 50*h/74);
      rotator(armX-w/4, armY+h/4.5, -PI/4, false);
      noStroke();
      fill(playerColor);
      quad(armX+w/3.5, armY-h/13.9, armX+w/10, armY+h/17, armX, armY, armX+w/6.6, armY-h/5.9);
      quad(armX+w/20, armY-h/25, armX-w/4.8, armY+h/7.5, armX-w/10, armY+h/6, armX+w/4.3, armY-h/50.5);
      stroke(0);
      strokeWeight(3);
      arc(armX+w/9.5+w/6, armY+h/16-h/12, w/2, h/3, -PI, (-0.4*PI/2.6)-PI/2, OPEN);
      arc(armX-w/9+w/7, armY-h/14, w/2, h/3.5, 0, PI/2-PI/20, OPEN);
      arc(armX-w/31+w/6, armY+h/4-h/12, w/1.5, h/2.5, -PI/2-3.6*PI/8.4, -PI/2 -0.6*PI/5.4, OPEN);
      arc(armX-w/2.55+w/6, armY+h/17-h/12, w/1.5, h/2.5, 0.2*PI/2.2, 3*PI/8, OPEN);
      arc(armX-w/2.8+w/6, armY+h/4-h/12, w/5.5, h/12, -0.3*PI/14.8, 3*PI/2, OPEN);
    }
  }
  void jump() {//jump
    if (totalJumps > 0) {//if jumps left and not movement locked
      if (abs(velocity.y) > SFC*18) velocity.add(0, SFC*-7);//if velocity over 12 add -8 to velocity
      else velocity.set(velocity.x, SFC*-7);//else velocity set -8
      grounded = false;
      totalJumps--;//decrement available jumps
      speedCheck();
      jump = true;
    }
  }

  void movementLR(boolean right) {//movement of player left and right
    if (right) {//if movement right
      directionChange('x', 1);//change x direction
      if (grounded) {//if grounded max movement velocity is 3 times speed multiplier
        if (velocity.x < SFC*3*speedMult) velocity.add(SFC*1*speedMult, 0);
      } else {//else max movement velocity is 2 times speed multiplier
        if (velocity.x < SFC*2*speedMult) velocity.add(SFC*.25*speedMult, 0);
      }
    } else {//if movement left
      directionChange('x', -1);//change x direction
      if (grounded) {//if grounded max movement velocity is 3 times speed multiplier
        if (velocity.x > SFC*-3*speedMult) velocity.add(SFC*-1*speedMult, 0);
      } else {//else max movement velocity is 2 times speed multiplier]
        if (velocity.x > SFC*-2*speedMult) velocity.add(SFC*-.25*speedMult, 0);
      }
    }
    speedCheck();
  }
  void directionChange(char axis, int value) {//changes direction of character without losing the last x direction
    if (axis == 'x') {
      if (value == 0 && direction.x != 0) savedXDirection = direction.x;
      direction.x = value;
    }
    if (axis == 'y') direction.y = value;
    if (direction.mag() == 0) direction.x = savedXDirection;
  }
  void attack() {//player attack
    if (attackCoolDown < 1) {//if attack cooldown is 0 attack based on weapon
      if (weapon.equals("unarmed")) punch();
      if (weapon.equals("pistol")) pistol();
      if (weapon.equals("uzi")) uzi();
      if (weapon.equals("shotgun")) shotgun();
      if (weapon.equals("cannon")) cannon();
    }
  }
  void punch() {//punch attack
    PVector lowerLA;//lower left attack hitbox point
    PVector upperRA;//upper right attack hitbox point
    armMove = true;
    if (direction.y != 0) {//if punching up or down
      if (direction.y == -1) {//if up
        upperRA = new PVector(position.x+3*size.x/4, position.y+direction.y*size.y);
        lowerLA = new PVector(position.x-3*size.x/4, position.y);
      } else {//if down
        upperRA = new PVector(position.x+3*size.x/4, position.y);
        lowerLA = new PVector(position.x-3*size.x/4, position.y+direction.y*size.y);
      }
    } else {//if punching left or right
      if (direction.x == 1) {//if right
        lowerLA = new PVector(position.x, position.y + size.y/4);
        upperRA = new PVector(position.x + direction.x*3*size.x/2, position.y - size.y/2);
      } else {//if left
        upperRA = new PVector(position.x, position.y - size.y/2);
        lowerLA = new PVector(position.x + direction.x*3*size.x/2, position.y + size.y/4);
      }
    }
    for (Player p : players) {//for all player other than this one
      if (p != this && hitBoxOverlap(lowerLA, upperRA, p.lowerL, p.upperR)) {//if their hitbox overlaps with attack hitbox
        p.knockBackMult += 1.5*damageMult;//add damage to their knockback mult
        if (direction.y == 0) p.velocity.add(SFC*p.knockBackMult*direction.x*cos(radians(-45)), SFC*p.knockBackMult*sin(radians(-45)));//if hitting left or right, hit at 45 degree angle
        else p.velocity.add(0, SFC*p.knockBackMult*direction.y);//if hitting up or down, hit up or down
        p.grounded = false;//unground them
      }
    }
    int a = 1;
    if (reloadMult < 1) a = 4/3;
    attackCoolDown = int(15*(reloadMult*a));//set attack cool down to 15 frames
  }
  void pistol() {
    projectiles.add(new Projectile(position.x, position.y, SFC*5*bulletSpeedMult*cos(direction.heading()), SFC*5*bulletSpeedMult*sin(direction.heading()), SFC*10, SFC*10, 1*damageMult, 1.15, 120, this));//spawn pistol bullet
    velocity.add(SFC*-1*cos(direction.heading()), SFC*-1*sin(direction.heading()));//add recoil to player velocity
    attackCoolDown = int(30*reloadMult);//set attack cool down to 30 frames
    ammo--;//decrement ammo
  }
  void uzi() {
    float rAngle = random(radians(-5), radians(5));//generate random angle between -5 and 5 degrees
    projectiles.add(new Projectile(position.x, position.y, SFC*10*bulletSpeedMult*cos(direction.heading()+rAngle), SFC*10*bulletSpeedMult*sin(direction.heading()+rAngle), SFC*3, SFC*3, .2*damageMult, .75, 40, this));//spawn uzi bullet with offset
    velocity.add(SFC*-.5*cos(direction.heading()), SFC*-.25*sin(direction.heading()));//add recoil to player velocity
    attackCoolDown = int(5*reloadMult);//set attack cool down to 5 frames
    ammo--;//decrement ammo
  }
  void shotgun() {
    projectiles.add(new Projectile(position.x, position.y, SFC*10*bulletSpeedMult*cos(direction.heading() + radians(-25)), SFC*10*bulletSpeedMult*sin(direction.heading() + radians(-25)), SFC*5, SFC*5, .4*damageMult, .45, 8, this));//spawn shotgun bullet
    projectiles.add(new Projectile(position.x, position.y, SFC*10*bulletSpeedMult*cos(direction.heading() + radians(-10)), SFC*10*bulletSpeedMult*sin(direction.heading() + radians(-10)), SFC*5, SFC*5, .3*damageMult, .45, 8, this));//spawn shotgun bullet
    projectiles.add(new Projectile(position.x, position.y, SFC*10*bulletSpeedMult*cos(direction.heading()), SFC*10*bulletSpeedMult*sin(direction.heading()), SFC*5, SFC*5, .2*damageMult, .45, 8, this));//spawn shotgun bullet
    projectiles.add(new Projectile(position.x, position.y, SFC*10*bulletSpeedMult*cos(direction.heading() + radians(10)), SFC*10*bulletSpeedMult*sin(direction.heading() + radians(10)), SFC*5, SFC*5, .3*damageMult, .45, 8, this));//spawn shotgun bullet
    projectiles.add(new Projectile(position.x, position.y, SFC*10*bulletSpeedMult*cos(direction.heading() + radians(25)), SFC*10*bulletSpeedMult*sin(direction.heading() + radians(25)), SFC*5, SFC*5, .4*damageMult, .45, 8, this));//spawn shotgun bullet
    velocity.add(SFC*-8*cos(direction.heading()), SFC*-6*sin(direction.heading()));//add recoil to player velocity
    attackCoolDown = int(70*reloadMult);//set attack cool down to 70 frames
    ammo--;//decrement ammo
  }
  void cannon() {
    projectiles.add(new Projectile(position.x, position.y, SFC*3*bulletSpeedMult*cos(direction.heading()), SFC*3*bulletSpeedMult*sin(direction.heading()), SFC*20, SFC*20, 1.5*damageMult, 4, 240, this));//spawn cannon ball
    velocity.add(SFC*-10*cos(direction.heading()), SFC*-8*sin(direction.heading()));//add recoil to player velocity
    attackCoolDown = int(90*reloadMult);//set attack cool down to 90 frames
    ammo--;//decrement ammo
  }
}

class PhysicsObject {
  PVector position = new PVector(0, 0);//position of object
  PVector pPosition = new PVector(0, 0);//previous position
  PVector velocity = new PVector(0, 0);//velocity of object
  PVector size = new PVector(50, 50);//size of object
  PVector lowerL;//lower left point of hitbox
  PVector upperR;//upper right point of hitbox
  boolean grounded = false;//whether object is actively colliding with a ground piece
  int ungroundedDelay = 2;//how many frames not colliding with ground until grounded is set to false
  boolean toBeRemoved = false;//whether object is marked to be removed from active object list

  PhysicsObject(float posX, float posY, float sizeX, float sizeY) {
    position.set(posX, posY);//set position
    pPosition.set(posX, posY);//set previous position to same value
    size.set(sizeX, sizeY);//set size
    lowerL = new PVector(position.x-size.x/2, position.y+size.y/2);//set lower left point of hitbox
    upperR = new PVector(position.x+size.x/2, position.y-size.y/2);//set upper right point of hitbox
  }
  void update() {
    pPosition.set(position.x, position.y);//set previous position to position before changes
    position.add(velocity.x, velocity.y);//add velocity to position
    lowerL = new PVector(position.x-size.x/2, position.y+size.y/2);//update lower left hitbox point
    upperR = new PVector(position.x+size.x/2, position.y-size.y/2);//update upper right hitbox point
    velocity.add(0, gravityAcceleration);//add acceleration due to gravity to velocity
    if (grounded) velocity.setMag(velocity.mag()*.8);//reduce velocity to 80% if grounded
    else velocity.setMag(velocity.mag()*.99);//reduce velocity to 99% if ungrounded
    boolean colliding = false;
    PVector halfStep = new PVector((position.x+pPosition.x)/2, (position.y+pPosition.y)/2);
    for (int i = 0; i < 2; i++) {//run ground check twice, once for a half step, then for the full step
      for (GroundPiece g : groundPieces) {//for each ground piece check for collision type
        int collisionType;
        if (i == 0) collisionType = g.collisionCheck(halfStep, size);//if on halfstep iteration
        else collisionType = g.collisionCheck(position, size);//else use full step
        if (collisionType != 0) {//if it is colliding
          groundCollision(g, collisionType);//run ground collision
          colliding = true;
        }
      }
      if (colliding) break;//if colliding on half step don't check fullstep
    }
    if (!colliding) {//if not colliding decrement ungrounded delay and if 0 set grounded to false
      ungroundedDelay--;
      if (ungroundedDelay == 0) grounded = false;
    } else ungroundedDelay = 2;
    speedCheck();//check so max speed/position change are not exceeded
  }
  void groundCollision(GroundPiece g, int surface) {//run ground collision based on collision type, for types see GroundPiece collisionCheck()
    if (surface == 1) {
      position.y = g.position.y - g.size.y/2 - size.y/2;
      if (velocity.y > 0) {
        if(velocity.y > 25*SFC) velocity.y *= -.5;
        else {
          velocity.y = 0;
          grounded = true;
        }
      }
    } else if (surface == 2) {
      position.x = g.position.x + g.size.x/2 + size.x/2;
      if (abs(velocity.x) < 5*SFC) velocity.x = 0;
      else velocity.x *= -.5;
      grounded = true;
    } else if (surface == 3) {
      position.y = g.position.y + g.size.y/2 + size.y/2;
      if (abs(velocity.y) > 5 && velocity.y < 0) velocity.y *= -.5;
      else if (abs(velocity.y) < 5*SFC && velocity.y < 0) velocity.y = 0;
    } else if (surface == 4) {
      position.x = g.position.x - g.size.x/2 - size.x/2;
      if (abs(velocity.x) < 5*SFC) velocity.x = 0;
      else velocity.x *= -.5;
      grounded = true;
    } else if (surface == 5) {
      if (velocity.y >= 0) {
        position.y = g.position.y - g.size.y/2 - size.y/2;
        velocity.y = 0;
        grounded = true;
      }
    }
  }
  void speedCheck() {//if current position has moved greater than max speed distance from previous position, or velocity exceeds max speed
    if (abs(pPosition.x-position.x) > maxSpeed || abs(pPosition.y-position.y) > maxSpeed) position.set(pPosition.x, pPosition.y);//keep at previous position
    if (velocity.mag() > maxSpeed) velocity.setMag(maxSpeed-.5);//cap velocity at .5 less than max speed
  }
}

class Projectile extends PhysicsObject {
  float damage = 0;//value prokectile adds to player knockback multiplier
  float impact = 0;//how much base knockback the projectile inflicts
  int lifeTimer;//how many frames the bullet stays active
  Player owner;//player who shot the projectile
  int directionX = 0;//x direction player is facing
  int directionY = 1;//y direction player is facing
  
  Projectile(float posX, float posY, float velX, float velY, float sizeX, float sizeY, float damage, float impact, int lifeTimer, Player owner) {//for generic bullets
    super(posX, posY, sizeX, sizeY);
    this.velocity.set(velX, velY);
    this.damage = damage;
    this.lifeTimer = lifeTimer;
    this.owner = owner;
    this.impact = impact;
    if(abs(velX) > 0.01) directionX = round(abs(velX)/velX);
    if(abs(velY) > 0.01) directionY = round(abs(velY)/velY);
  }
  
  void run() {
    updateProjectile();//projectile specific updates, modified physicsObject.update() method
    render();//render projectile
  }
  void updateProjectile() {//projectile specific updates, modified physics object update() method
    position.add(velocity.x, velocity.y);//add velocity to position
    lowerL = new PVector(position.x-size.x/2,position.y+size.y/2);//update lower left hitbox point
    upperR = new PVector(position.x+size.x/2,position.y-size.y/2);//update upper right hitbox point
    for(GroundPiece g : groundPieces) {//check all ground pieces for collision
      int collisionType = g.collisionCheck(position, size);
      if(collisionType != 0 && collisionType != 5) toBeRemoved = true;//if colliding with a solid piece mark to be removed
    }
    for(Player p : players) {//check all players for colllision
      if(p != owner && hitBoxOverlap(lowerL, upperR, p.lowerL, p.upperR)) {//if colliding and not the owner of the projectile
        if(p.invincibleFrames < 1) {//if player is not invincible
          p.knockBackMult += damage;//add damage to player
          
          if(abs(velocity.y) > abs(velocity.x)) p.velocity.add(0,SFC*p.knockBackMult*impact*directionY);//add knockback*damage to player in the direction of the bullet
          else p.velocity.add(SFC*p.knockBackMult*impact*directionX*cos(radians(-25)),SFC*p.knockBackMult*impact*directionY*sin(radians(-25)));//add knockback*damage to player in the direction of the bullet
          p.speedCheck();//keep within max speed
          p.grounded = false;
        }
        toBeRemoved = true;//mark as to be removed
      }
    }
    lifeTimer--;//decrement life timer
    if(lifeTimer < 0) toBeRemoved = true;//if timer is 0 mark as to be removed
  }
  void render() {//render projectile
    fill(255);
    ellipse(position.x, position.y, size.x, size.y);
  }
}
}

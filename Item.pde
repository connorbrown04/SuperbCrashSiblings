class Item extends PhysicsObject {
  String type = "empty";
  PImage icon;
  int ammo = 0;
  int lifeTimer = 600;//10 seconds to despawn
  
  Item(float posX, float posY, String type, int ammo) {
    super(posX, posY, SFC*25, SFC*25);//set position and size
    float rAngle = random(radians(-100),radians(-80));
    velocity.set(5*cos(rAngle), 5*sin(rAngle));
    this.type = type;//set contents of item
    this.ammo = ammo;//set ammo amount
    icon = loadImage("crate.png");
  }
  void run() {
    update();//run physics
    updateItem();//run item specific update
    render();//render item
  }
  void updateItem() {//run item specific update
    for(Player p : players) {//for every player, if hit boxes are overlapping, give weapon and ammo and mark item to be removed
      if(hitBoxOverlap(lowerL, upperR, p.lowerL, p.upperR)) {
        p.weapon = type;
        p.ammo = int(ammo * p.ammoMult);
        toBeRemoved = true;
      }
    }
    lifeTimer--;//decrement life timer
    if(lifeTimer < 0) toBeRemoved = true;//if life timer is 0 despawn
  }
  void render() {//render circle
    imageMode(CENTER);
    image(icon, position.x, position.y, size.x, size.y);
  }
}

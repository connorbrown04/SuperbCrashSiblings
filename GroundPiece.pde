class GroundPiece {
  PVector position;//position of piece
  PVector size;//size of piece
  boolean horizontal = true;//if piece is horizontal
  boolean semiSolid = false;//if piece is semisolid
  PImage texture;//texture of piece
  
  GroundPiece(float[] hitboxInfo) {
    position = new PVector(hitboxInfo[0], hitboxInfo[1]);//set position
    size = new PVector(hitboxInfo[2], hitboxInfo[3]);//set size
    if(hitboxInfo[4] == 0) horizontal = false;//set horizontal/vertical
    texture = loadImage(mapImageInfo[currentMap][int(hitboxInfo[5])]);//set texture
    if(hitboxInfo.length > 6) if(hitboxInfo[6] == 1) semiSolid = true;//set if semi solid
  }
  int collisionCheck(PVector objPosition, PVector objSize) {//returns type of collision with piece, 0: not colliding, 1: top of solid, 2: right, 3: bottom of solid, 4: left, 5: top of semiSolid
    if((objPosition.x + objSize.x/2 > position.x - size.x/2) && (objPosition.x - objSize.x/2 < position.x + size.x/2) && (objPosition.y + objSize.y/2 > position.y - size.y/2) && (objPosition.y - objSize.y/2 < position.y + size.y/2)) {//if colliding
      if(!semiSolid) {
        if(horizontal) {//if horizontal, use thicker top and bottom hitboxes
          if((objPosition.y + objSize.y/2 > position.y - size.y/2) && (objPosition.y + objSize.y/2 < position.y - 2*size.y/8)) return 1;//if hitting top hitbox
          else if((objPosition.y - objSize.y/2 < position.y + size.y/2) && (objPosition.y - objSize.y/2 > position.y + 2*size.y/8)) return 3;//if hitting bottom hitbox
          else if((objPosition.x - objSize.x/2 < position.x + size.x/2) && (objPosition.x - objSize.x/2 > position.x + 14*size.x/30)) return 2;//if hitting right hitbox
          else if((objPosition.x + objSize.x/2 > position.x - size.x/2) && (objPosition.x + objSize.x/2 < position.x - 14*size.x/30)) return 4;//if hitting left hitbox
          else if((objPosition.y + objSize.y/2 > position.y - size.y/2) && (objPosition.y + objSize.y/2 < position.y + 4*size.y/8)) return 1;//if hitting top hitbox and not left or right
          else if((objPosition.y - objSize.y/2 < position.y + size.y/2) && (objPosition.y - objSize.y/2 > position.y - 4*size.y/8)) return 3;//if hitting bottom hitbox and not left or right
          else return 1;//else hitting top hitbox
        } else {//if vertical, use thicker left and right hitboxes
          if((objPosition.y + objSize.y/2 > position.y - size.y/2) && (objPosition.y + objSize.y/2 < position.y - 14*size.y/30)) return 1;//if hitting top hitbox
          else if((objPosition.y - objSize.y/2 < position.y + size.y/2) && (objPosition.y - objSize.y/2 > position.y + 14*size.y/30)) return 3;//if hitting bottom hitbox
          else if((objPosition.x - objSize.x/2 < position.x + size.x/2) && (objPosition.x - objSize.x/2 > position.x + 1*size.x/8)) return 2;//if hitting right hitbox
          else if((objPosition.x + objSize.x/2 > position.x - size.x/2) && (objPosition.x + objSize.x/2 < position.x - 1*size.x/8)) return 4;//if hitting left hitbox
          else if((objPosition.x - objSize.x/2 < position.x + size.x/2) && (objPosition.x - objSize.x/2 > position.x + 4*size.x/8)) return 2;//if hitting top hitbox and not left or right
          else if((objPosition.x + objSize.x/2 > position.x - size.x/2) && (objPosition.x + objSize.x/2 < position.x - 4*size.x/8)) return 4;//if hitting bottom hitbox and not left or right
          else return 1;//else hitting top hitbox
        }
      } else {//if semiSolid, check top hit box and return special collision type
        if(position.y-size.y/2 < objPosition.y + objSize.y/2 && position.y-2*size.y/8 > objPosition.y + objSize.y/2) return 5;//if hitting top of semiSolid
        else return 0;//else not hitting
      }
    }
    return 0;//else not hitting
  }
  void render() {//render piece based on texture
    imageMode(CENTER);
    image(texture, position.x, position.y, size.x+SFC*120, size.y+SFC*120);
  }
}

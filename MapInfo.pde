
float[][][] mapHitBoxInfo;
float[][][][] mapSpawnInfo;
String[][] mapImageInfo;
void mapInfoConstructor() {
  mapHitBoxInfo = new float[][][]
    {//[map number][individual hitboxes][x, y, width, height, is horizontal, texture ID, semiSolid(optional)]
    {//map 0 (testing map) hitboxes
      {SFC*650, SFC*600, SFC*1000, SFC*30, 1, 0},
      {SFC*650, SFC*200, SFC*300, SFC*50, 1, 0},
      {SFC*812.5, SFC*650, SFC*50, SFC*300, 0, 1, 1}
    },
    {//map 1 hitboxes
      {SFC*250, SFC*440, SFC*300, SFC*25, 1, 1, 1}, //left
      {SFC*1050, SFC*440, SFC*300, SFC*25, 1, 1, 1}, //right
      {SFC*650, SFC*330, SFC*300, SFC*25, 1, 1, 1}, //middle top
      {SFC*650, SFC*600, SFC*1000, SFC*30, 1, 2}//middle bottom
    },
    {//map 2 hitboxes
      {SFC*650, SFC*500, SFC*2000, SFC*100, 0, 1}, //main block
      {SFC*650, SFC*450, SFC*2000, SFC*10, 1, 2}//top layer of block
    },
    {//map 3 hitboxes
      {SFC*650, SFC*1000, SFC*1002, SFC*1100, 1, 3}, //center
      {SFC*100, SFC*500, SFC*100, SFC*1100, 0, 1}, //left wall
      {SFC*1200, SFC*500, SFC*100, SFC*1100, 0, 2}//right wall
    },
    {//map 4 hitboxes
      {SFC*650, SFC*600, SFC*1000, SFC*30, 1, 1}, //main bottom
      {SFC*650, SFC*540, SFC*180, SFC*90, 1, 2}, //middle pedestal
      {SFC*650, SFC*330, SFC*180, SFC*30, 1, 3}, //middle platform
      {SFC*300, SFC*440, SFC*150, SFC*25, 1, 4}, //left lower ledge
      {SFC*1000, SFC*440, SFC*150, SFC*25, 1, 5}, //right lower ledge
      {SFC*402, SFC*158, SFC*150, SFC*25, 1, 6}, //left upper ledge
      {SFC*898, SFC*158, SFC*150, SFC*25, 1, 7}, //right upper ledge
      {SFC*350, SFC*290, SFC*51, SFC*290, 0, 8}, //left wall
      {SFC*950, SFC*290, SFC*51, SFC*290, 0, 9}//right wall
    },
    {//map 5 hitboxes
      {SFC*650, SFC*630, SFC*800, SFC*60, 1, 1}, //main pedestal
      {SFC*350, SFC*290, SFC*50, SFC*290, 0, 2}, //outer left floating wall
      {SFC*950, SFC*290, SFC*50, SFC*290, 0, 2}, //outer right floating wall
      {SFC*450, SFC*475, SFC*75, SFC*250, 0, 3}, //inner left wall
      {SFC*850, SFC*475, SFC*75, SFC*250, 0, 4}, //inner right wall
      {SFC*650, SFC*450, SFC*75, SFC*300, 0, 5},//center wall
      {SFC*650, SFC*100, SFC*75, SFC*200, 0, 6},//center floating wall
      {SFC*650, SFC*675, SFC*1000, SFC*30, 1, 7} //main platform
    },
    {//map 6 hitboxes
      {SFC*340, SFC*440, SFC*300, SFC*25, 1, 1, 1}, //middle left
      {SFC*960, SFC*440, SFC*300, SFC*25, 1, 1, 1}, //middle right
      {SFC*340, SFC*280, SFC*300, SFC*25, 1, 1, 1}, //top left
      {SFC*960, SFC*280, SFC*300, SFC*25, 1, 1, 1}, //top right
      {SFC*340, SFC*600, SFC*300, SFC*25, 1, 1, 1}, //bottom left
      {SFC*960, SFC*600, SFC*300, SFC*25, 1, 1, 1} //bottom right
    }
  };

  mapSpawnInfo = new float[][][][]
    {//[map number][0: player spawns, 1: item spawns][spawn id][x, y]
    {//map 0 (testing map) spawn points
      {//player spawns
        {SFC*650, SFC*400},
        {SFC*1300, SFC*400}
      },
      {//item spawns
        {SFC*325, SFC*400}
      }
    },
    {//map 1 spawn points
      {//player spawns
        {SFC*250, SFC*400},
        {SFC*1050, SFC*400},
        {SFC*650, SFC*280}
      },
      {//item spawns
        {SFC*250, SFC*365},
        {SFC*1050, SFC*365},
        {SFC*650, SFC*225},
        {SFC*650, SFC*495}
      }
    },
    {//map 2 spawn points
      {//player spawns
        {SFC*150, SFC*400},
        {SFC*1150, SFC*400},
        {SFC*650, SFC*400}
      },
      {//item spawns
        {SFC*150, SFC*400},
        {SFC*1150, SFC*400}
      }
    },
    {//map 3 spawn points
      {//player spawns
        {SFC*200, SFC*400},
        {SFC*1100, SFC*400},
        {SFC*650, SFC*400}
      },
      {//item spawns
        {SFC*200, SFC*400},
        {SFC*1100, SFC*400}
      }
    },
    {//map 4 spawn points
      {//player spawns
        {SFC*200, SFC*400},
        {SFC*1100, SFC*400},
        {SFC*650, SFC*400}
      },
      {//item spawns
        {SFC*400, SFC*100},
        {SFC*900, SFC*100}
      }
    },
    {//map 5 spawn points
      {//player spawns
        {SFC*200, SFC*500},
        {SFC*1100, SFC*500},
        {SFC*650, SFC*250}
      },
      {//item spawns
        {SFC*650, SFC*15},
        {SFC*650, SFC*15},
        {SFC*650, SFC*15},
        {SFC*550, SFC*550},
        {SFC*750, SFC*550},
      }
    },
    {//map 6 spawn points
      {//player spawns
        {SFC*340, SFC*400},
        {SFC*960, SFC*400},
        {SFC*340, SFC*240},
        {SFC*960, SFC*240},
        {SFC*340, SFC*560},
        {SFC*960, SFC*560}
      },
      {//item spawns
        {SFC*650, SFC*0}
      }
    }
  };
  mapImageInfo = new String[][]//[current map][texture file name]
    {
    {"brick.jpg"}, //map 0
    {"M1Background.png", "M1A1.png", "M1A2.png"}, //map 1
    {"M2Background.png", "M2A1.png", "M2A2.png"}, //map 2
    {"M3Background.png", "M3A1.png", "M3A2.png", "M3A3.png"}, //map 3
    {"M4Background.png", "M4A1.png", "M4A2.png", "M4A3.png", "M4A4.png", "M4A5.png", "M4A6.png", "M4A7.png", "M4A8.png", "M4A9.png",}, //map 4
    {"M5Background.png", "M5A1.png", "M5A2.png", "M5A3.png", "M5A4.png", "M5A5.png", "M5A6.png", "M5A7.png"}, //map 5
    {"M6Background.png", "M6A1.png"}//map 6
  };
}

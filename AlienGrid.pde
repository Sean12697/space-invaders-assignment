class AlienGrid {
  Alien[][] alien;
  PVector fixedPos;
  int cols, rows, aliensLeft, rowMin, rowMax;
  Boolean moveRight;

  AlienGrid(int cols, int rows) {
    this.cols = cols;
    this.rows = rows;
    resetFixedPos();
    moveRight = true;
    alien = new Alien[cols][rows];
  }

  void populateArray() {
    for (int i=0; i<cols; i++) {
      for (int j=0; j<rows; j++) {
        alien[i][j] = new Alien(i, j, fixedPos);
      }
    }
  }

  void resetFixedPos() {
    this.fixedPos = new PVector(50, 60);
  }

  void ingameVaribleReset() {
    rowMin = 10;
    rowMax = 1;
    aliensLeft = 0;
  }

  void varibleReset() {
    ingameVaribleReset();
    moveRight = true;
  }

  void render(Bullet bullet, Defender player) {
    for (int i=0; i<cols; i++) {
      for (int j=0; j<rows; j++) {

        if (alien[i][j] != null) { //If Alien at index exists
          if (!alien[i][j].dead) {
            if (bullet != null && level > round(random(100))) { // 1:100 chance dodge at level 1, 1:1 at level 100
              alien[i][j].avoidBullet();
            }

            alien[i][j].render(fixedPos);
            aliensLeft++; //States the array is not empty
            int n = i + 1;
            if (n < rowMin) { 
              rowMin = n;
            } //Puts the futhest left index as min
            if (n > rowMax) { 
              rowMax = n;
            } //Puts the futhest right index as max

            if (alien[i][j].missile != null) { //If alien has a shot missile
              alien[i][j].missile.update(); //Update bullet

              if (alien[i][j].missile.pos.y > height) { //tests bullets position
                alien[i][j].missile = null;
              } else if (alien[i][j].missile.pos.dist(player.pos) < 20) { //If player shot
                alien[i][j].missile = null;
                player.lostLife = true;
                player.lives--;
              } 

              if (bullet != null && alien[i][j].missile != null) {
                if (alien[i][j].missile.pos.dist(bullet.pos) < 12) { //If player bullet and alien bullet hit each other
                  alien[i][j].missile = null;
                  bullet = null;
                }
              }
            } else {
              alien[i][j].randomShoot(level); //Generate bullet
            }
          }
        }
        if (alien[i][j] != null) {
          if (alien[i][j].dead) {
            alien[i][j] = null;
          }
        }
      }
    }
  }

  void move() { //rowMin & rowMax need fixing since not moving
    float move = ((level-1)*0.1)+1; 
    //Level 1 = 1 (0 * 0.1 = 0 + 1 = 1)
    //Level 2 = 1.5 (1 * 0.1 = 0.1 + 1 = 1.1)
    if ((fixedPos.x + (rowMin*60)) - 100 < 0) {
      moveRight = true;
      fixedPos.add(0, 10);
    }
    if (fixedPos.x + (rowMax*60) > width) {
      moveRight = false;
      fixedPos.add(0, 10);
    }
    if (moveRight == true) {
      fixedPos.add(move, 0);
    }
    if (moveRight == false) {
      fixedPos.sub(move, 0);
    }
  }

  Collision alienShot(Bullet bullet) {
    Collision shot; //for return
    for (int i=0; i<alienCol; i++) {
      for (int j=0; j<alienRow; j++) {
        if (alien[i][j] != null && !alien[i][j].dying) {
          //Goes through each alien that is not null
          //If distance between the bullet and an alien is less then 20 pixels
          if (bullet.pos.dist(alien[i][j].pos) < 20) {
            //Say there is a collision and return the alien index
            return shot = new Collision(true, i, j);
          }
        }
      }
    }
    return shot = new Collision(false, 0, 0);
  }

  void update(Bullet bullet, Defender player) {
    aliens.render(bullet, player);
    aliens.move();
  }

  void resetAliens() {
    resetFixedPos();
    populateArray();
  }
}
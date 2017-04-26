class Bullet {
  PVector pos, vel;
  int level;
  boolean player, tracking;
  twoDimensionArrayIndex nearestAlien;

  Bullet(PVector pos, int level, boolean player, boolean tracking) {
    this.pos = new PVector(pos.x, pos.y);
    this.player = player; //From the player or alien
    this.tracking = tracking; //For tracking bullets
    if (this.player) { //From Player
      this.vel = new PVector(0, -20); //Set to move up screen
      if (this.tracking) { 
        this.nearestAlien = this.getNearestAlienIndex(); //AlienIndex to track and not use a copy which will have the x/y of when captured
      }
    }
    if (!this.player) { //From Alien
      this.vel = new PVector(0, (level*0.1)+5); //Set to move down screen
    } //Allows leveling
  }

  void render() {
    if (tracking) { //Tracking Bullet
      fill(0, 255, 0); //Green
      ellipse(pos.x, pos.y, 10, 10);
    } else {
      if (player) { //From Player
        fill(0, 255, 255); //Cyan
        ellipse(pos.x, pos.y, 10, 10);
      }
      if (!player) { //From Alien
        fill(255, 0, 0); //Red
        ellipse(pos.x, pos.y, 10, 10);
      }
    }
  }

  void move() {
    if (tracking && nearestAlien != null) {
      vel.x = xoffAlien(); //Add tracking offset (along x)
    }
    pos.add(vel); //Add velosity to possition
    vel.x = 0; //Resets x offset
  }

  float nearestAlienDist() {
    return pos.dist(aliens.alien[nearestAlien.i][nearestAlien.j].pos); //Distance between bullets pos' and nearestAlien pos'
  }

  float xoffAlien() {
    Alien alien = aliens.alien[nearestAlien.i][nearestAlien.j]; //Creates a temp' alien from nearestAlien index for following function code
    if (alien == null || alien.dying) { //Since a bullet can be shot and then an alien can die before completion
      nearestAlien = getNearestAlienIndex(); //Get a new nearest Alien index
    }
    if (alien != null) {
      if (pos.x > alien.pos.x) { //If bullet is right of the alien, move left (negative x)
        return -(nearestAlienDist()/40); //Moves 1/40 nearer to the alien it is aiming towards
      }
      if (pos.x < alien.pos.x) { //If bullet is left of the alien, move right (positive x)
        return nearestAlienDist()/40; //Moves 1/40 nearer to the alien it is aiming towards
      }
    }
    return 0; //If all fails, no offset
  }

  twoDimensionArrayIndex getNearestAlienIndex() {
    twoDimensionArrayIndex nearest = null;
    float nearestLocationDist = 10000; //High number to ensure there's a closer alien
    for (int i=0; i<alienCol; i++) {
      for (int j=0; j<alienRow; j++) {
        if (aliens.alien[i][j] != null) {
          if (pos.dist(aliens.alien[i][j].pos) < nearestLocationDist) { //If the distance is less then one it has found before (or the high default)
            nearest = new twoDimensionArrayIndex(i, j); //used to track an alien, instead of creating a copy with will have a fixed position of when it was copied
            nearestLocationDist = pos.dist(aliens.alien[i][j].pos);
          }
        }
      }
    }
    return nearest;
  }

  void update() {
    render();  
    move();
  }
}
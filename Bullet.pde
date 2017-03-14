class Bullet {
  PVector pos, vel;
  int level;
  boolean player, tracking;
  twoDimensionArrayIndex nearestAlien;

  Bullet(PVector pos, int level, boolean player, boolean tracking) {
    this.pos = new PVector(pos.x, pos.y);
    this.player = player;
    this.tracking = tracking;
    if (this.player == true) { 
      this.vel = new PVector(0, -20);
      if (this.tracking) {
        this.nearestAlien = this.getNearestAlienIndex();
      }
    }
    if (this.player == false) { 
      this.vel = new PVector(0, (level*0.1)+5);
    } //Allows leveling
  }

  void render() {
    if (tracking) {
      fill(0, 255, 0);
      ellipse(pos.x, pos.y, 10, 10);
    } else {
      if (player == true) {
        fill(0, 255, 255);
        ellipse(pos.x, pos.y, 10, 10);
      }
      if (player == false) {
        fill(255, 0, 0);
        ellipse(pos.x, pos.y, 10, 10);
      }
    }
  }

  void move() {
    if (tracking && nearestAlien != null) {
      vel.x = xoffAlien();
    }
    pos.add(vel);
    vel.x = 0;
  }

  float nearestAlienDist() {
    return pos.dist(aliens.alien[nearestAlien.i][nearestAlien.j].pos);
  }

  float xoffAlien() {
    Alien alien = aliens.alien[nearestAlien.i][nearestAlien.j];
    if (alien == null || alien.dying) { //Since a bullet can be shot and then an alien can die before completion
      nearestAlien = getNearestAlienIndex();
    }
    if (alien != null) {
      if (pos.x > alien.pos.x) { //If bullet is right of the alien, move left (negative x)
        return -(nearestAlienDist()/40); //Moves 1/40 nearer to the alien it is aiming towards
      }
      if (pos.x < alien.pos.x) { //If bullet is left of the alien, move right (positive x)
        return nearestAlienDist()/40;
      }
    }
    return 0;
  }

  twoDimensionArrayIndex getNearestAlienIndex() { //Collision used since it encapulates an i & j (index of an alien)
    twoDimensionArrayIndex nearest = null;
    float nearestLocationDist = 10000;
    for (int i=0; i<alienCol; i++) {
      for (int j=0; j<alienRow; j++) {
        if (aliens.alien[i][j] != null) {
          if (pos.dist(aliens.alien[i][j].pos) < nearestLocationDist) {
            nearest = new Collision(i, j); //used to track an alien, instead of creating a copy with will have a fixed position of when it was copied
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
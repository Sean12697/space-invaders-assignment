class Bullet {
  PVector pos, vel;
  int level;
  boolean player, tracking;
  Collision nearestAlien;

  Bullet(PVector pos, int level, boolean player, boolean tracking) {
    this.pos = new PVector(pos.x, pos.y);
    this.player = player;
    this.tracking = tracking;
    if (this.player == true) { 
      this.vel = new PVector(0, 20);
      if (this.tracking) {
        this.nearestAlien = this.getNearestAlienIndex();
      }
    }
    if (this.player == false) { 
      this.vel = new PVector(0, (level*0.1)+5);
    } //Allows leveling
  }

  void render() {
    if (player == true) {
      fill(0, 255, 255);
      ellipse(pos.x, pos.y, 10, 10);
    }
    if (player == false) {
      fill(255, 0, 0);
      ellipse(pos.x, pos.y, 10, 10);
    }
  }

  void move() {
    if (player == true) {
      if (tracking) {
        vel.x = xoffAlien();
      }
      pos.sub(vel);
      vel.x = 0;
    }
    if (player == false) {
      pos.add(vel);
    }
  }

  float xoffAlien() {
    if (alien[nearestAlien.i][nearestAlien.j] == null) { //Since a bullet can be shot and then an alien can die before completion
      nearestAlien = getNearestAlienIndex();
    }
    if (pos.x > alien[nearestAlien.i][nearestAlien.j].pos.x) { //If bullet is right of the alien, move left (negative x)
      return 5; //Inverted due to vector being subtracted instead of added (since it move up the screen)
    }
    if (pos.x < alien[nearestAlien.i][nearestAlien.j].pos.x) { //If bullet is left of the alien, move right (positive x)
      return -5; //Inverted due to vector being subtracted instead of added (since it move up the screen)
    }
    return 0;
  }

  Collision getNearestAlienIndex() { //Collision used since it encapulates an i & j (index of an alien)
    Collision nearest = new Collision();
    float nearestLocationDist = 10000;
    for (int i=0; i<alienCol; i++) {
      for (int j=0; j<alienRow; j++) {
        if (alien[i][j] != null) {
          if (pos.dist(alien[i][j].pos) < nearestLocationDist) {
            nearest = new Collision(i, j);
            nearestLocationDist = pos.dist(alien[i][j].pos);
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
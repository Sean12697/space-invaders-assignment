class Defender {
  PVector pos, vel;
  boolean moveLeft, moveRight;

  Defender() {
    pos = new PVector(width/2, height-50);
    vel = new PVector (5, 0);
    moveLeft = false;
    moveRight = false;
  }

  void render() {
    movement();
    fill(random(255), random(255), random(255));
    rect(pos.x-20, pos.y-20, 40, 40);
  }

  void movement() {
    if (moveLeft && player.pos.x -20 > 0) {
      player.pos.sub(player.vel);
    }
    if (moveRight && player.pos.x + 20 < width) {
      player.pos.add(player.vel);
    }
  }

  void lostLife() {
    //Animation
  }
}
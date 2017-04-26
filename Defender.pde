class Defender {
  PVector pos, vel;
  boolean moveLeft, moveRight, lostLife;
  int damage, score, lives, bulletsShot, counter;

  Defender() {
    varibleReset();
    pos = new PVector(width/2, height-50);
    vel = new PVector (5, 0);
    moveLeft = false;
    moveRight = false;
    damage = 40; //40
  }

  void varibleReset() {
    score = 0;
    lives = 3; 
    bulletsShot = 0;
    lostLife = false;
    counter = 0;
  }

  void render() {
    movement();
    //Show square with changing colours, when not lost a life, then flicker every 10/60th a second if lost a life
    if (!lostLife || (lostLife && counter % 10 == 0)) {
      fill(random(255), random(255), random(255));
      rect(pos.x-20, pos.y-20, 40, 40);
    }
    if (lostLife) {
      counter++;
      if (counter > 120) { //Reset
        counter = 0;
        lostLife = false;
      }
    }
  }

  void movement() {
    if (moveLeft && player.pos.x -20 > 0) { //If moving left and not off the screen
      player.pos.sub(player.vel);
    }
    if (moveRight && player.pos.x + 20 < width) { //If moving right and not off the screen
      player.pos.add(player.vel);
    }
  }
}
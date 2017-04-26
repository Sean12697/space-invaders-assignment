class Alien {
  PVector relPos, pos, offset;
  Boolean dying, dead;
  int deathCounter, counter;
  float health, healthMax;
  PImage[] seq = new PImage[4];
  PImage[] death = new PImage[12];
  Bullet missile;

  Alien(int i, int j, PVector fixedPos) {
    relPos = new PVector(i*60, j*60); //Used to seperate the aliens
    offset = new PVector(0, 0); //Will be used to dodge
    calPos(fixedPos); //Method to add a relative to fixed, to calculate the x/y
    missile = null;
    for (int n = 0; n < seq.length; n++) {
      seq[n] = loadImage("img/alien_seq" + (n + 1) + ".png"); //File string concatination
    }
    for (int n = 0; n < death.length; n++) {
      death[n] = loadImage("img/alien_death" + (n + 1) + ".png");
    }
    dying = false;
    dead = false;
    deathCounter = 0;
    counter = 1;
    health = (level*2)+30; //30 (increase to debug)
    healthMax = new Float(health);
  }

  Alien() {
    //Blank constructer created to initate a blank alien
  }

  void render(PVector fixedPos) {
    calPos(fixedPos);
    if (!dying) { //if in a not dying state
      renderAlienNormal();
      if (counter >= 19) {
        counter = 1; //Reset
      }
    }
    if (dying) {
      //Use an image in the array, flooring for an int/index, then using a count divided by a x/60th of a second
      image(death[floor(deathCounter/5)], pos.x - 20, pos.y - 20);
      deathCounter++;
      if (deathCounter >= 59) { //Until it can keep indexing, the array size (12) by the delay (5), negating 1 (60/5 would be 12, outOfBounds)
        dead = true; //Will be used to set to null
      }
    }
  }

  void renderAlienNormal() {
    float t = map(health/healthMax, 0, 1, 255, 0); //converts health persentage to a 8-bit channel value (0 = 255, 0.5 = 127, 1 = 0)
    tint(255, 255 - t, 255 - t); //Adds a tint of red when the t goes down (controlled by the health above)
    image(seq[floor(counter/5)], pos.x - 20, pos.y - 20); //Same method as death image array
    noTint(); //Resets tint for following images
    
    //Health bar
    stroke(255);
    line(pos.x - 20, pos.y - 25, pos.x + 20, pos.y - 25);
    stroke(255, 0, 0);
    line(pos.x - 20, pos.y - 25, pos.x + (((health/healthMax)*40)-20), pos.y - 25);
    
    counter++;
  }

  void calPos(PVector fixedPos) {
    PVector fp = fixedPos.copy(); //Stops the fixedPos from being overwritten by the following line
    pos = fp.add(relPos);
    pos.add(offset);
  }

  void randomShoot(int level) {
    //Level 1 = 1:5000
    //Level 10 = 1:500
    int i = floor(random(5000/level));
    if (i == 1) {
      missile = new Bullet(pos, level, false, false);
    }
  }

  void avoidBullet() {
    if (bulletNear()) {
      offset.x = bulletX();
    }
  }

  float bulletX() {
    float dist = pos.x - bullet.pos.x;
    if (dist > 1) { 
      return 10;
    }
    if (dist < 1) { 
      return -10;
    }
    return 0;
  }

  boolean bulletNear() {
    if (bullet.pos.dist(pos) < 30) {
      return true;
    } 
    return false;
  }
}
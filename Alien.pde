class Alien {
  PVector relPos, pos, offset;
  Boolean dying, dead;
  int deathCounter, counter;
  float health, healthMax;
  PImage[] seq = new PImage[4];
  PImage[] death = new PImage[12];
  Bullet missile;

  Alien(int i, int j, PVector fixedPos) {
    relPos = new PVector(i*60, j*60);
    offset = new PVector(0, 0);
    calPos(fixedPos);
    missile = null;
    for (int n = 0; n < seq.length; n++) {
      seq[n] = loadImage("img/alien_seq" + (n + 1) + ".png");
    }
    for (int n = 0; n < death.length; n++) {
      death[n] = loadImage("img/alien_death" + (n + 1) + ".png");
    }
    dying = false;
    dead = false;
    deathCounter = 0;
    counter = 1;
    health = (level*2)+150; //30
    healthMax = new Float(health);
  }

  void render(PVector fixedPos) {
    calPos(fixedPos);
    if (dying == false) {
      float t = 255 - map(health/healthMax, 0, 1, 0, 255);
      //if (health != healthMax) { tint(t, 255, 255); } 
      tint(t, t - 255, t - 255);
      image(seq[floor(counter/5)], pos.x - 20, pos.y - 20);
      noTint();
      stroke(255);
      line(pos.x - 20, pos.y - 25, pos.x + 20, pos.y - 25);
      stroke(255, 0, 0);
      line(pos.x - 20, pos.y - 25, pos.x + (((health/healthMax)*40)-20), pos.y - 25);
      counter++;
      if (counter >= 19) {
        counter = 1;
      }
    }
    if (dying == true) {
      image(death[floor(deathCounter/5)], pos.x - 20, pos.y - 20);
      deathCounter++;
      if (deathCounter >= 59) {
        dead = true;
      }
    }
  }

  void calPos(PVector fixedPos) {
    PVector fp = fixedPos.copy();
    pos = fp.add(relPos);
    PVector pc = pos.copy();
    pos = pc.add(offset);
  }

  void randomShoot(int level) {
    //Level 1 = 1:2000
    //Level 10 = 1:200
    int i = floor(random(200*(11-level)));
    if (i == 1) {
      missile = new Bullet(pos, level, false);
    }
  }
  
  void avoidBullet() {
    if(bulletNear()) {
      offset.x = 0;
      offset.x += bulletX();
    }
  }
  
  float bulletX() {
    float dist = pos.x - bullet.pos.x;
    if (dist > 1) { return 10; }
    if (dist < 1) { return -10; }
    else { return 0; }
  }
  
  boolean bulletNear() {
    if (bullet.pos.dist(pos) < 30) {
      return true;
    } return false;
  }
  
}
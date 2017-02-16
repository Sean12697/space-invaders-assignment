class Alien {
  PVector relPos, pos;
  Boolean dying, dead;
  int deathCounter, counter;
  PImage[] seq = new PImage[4];
  PImage[] death = new PImage[12];

  Bullet missile;

  Alien(int i, int j, PVector fixedPos) {
    this.relPos = new PVector(i*60, j*50);
    PVector fp = fixedPos.copy();
    this.pos = fp.add(relPos);
    this.missile = null;
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
  }

  void render(PVector fixedPos) {
    if (dying == false) {
      PVector fp = fixedPos.copy();
      this.pos = fp.add(relPos);
      image(seq[floor(counter/5)], pos.x - 20, pos.y - 20);
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

  void randomShoot(int level) {
    //Level 1 = 1:1000
    //Level 10 = 1:100
    int i = floor(random(100*(11-level)));
    if (i == 1) {
      missile = new Bullet(pos, level, false);
    }
  }
}
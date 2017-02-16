class Alien {
  PVector relPos, pos;
  Bullet missile;
  
  Alien(int i, int j, PVector fixedPos) {
   this.relPos = new PVector(i*60, j*50);
   PVector fp = fixedPos.copy();
   this.pos = fp.add(relPos);
   this.missile = null;
  }
  
  void render(PVector fixedPos) {
   PVector fp = fixedPos.copy();
   this.pos = fp.add(relPos);
   
   stroke(0);
   fill(0,255,0);
   ellipse(pos.x,pos.y,30,30);
   fill(50,100,0);
   ellipse(pos.x,pos.y,50,15);
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
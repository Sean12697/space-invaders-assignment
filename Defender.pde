class Defender {
  PVector pos, vel;
  
  Defender() {
    pos = new PVector(width/2, height-50);
    vel = new PVector (10, 0);
  }
  
  void render() {
    fill(255,0,255);
    rect(pos.x-20,pos.y-20,40,40);
  }
  
  void lostLife() {
    //Animation
  }
}
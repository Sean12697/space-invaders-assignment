class Bullet {
  PVector pos;
  float vel;
  int level;
  boolean player;

  Bullet(PVector pos, int level, boolean player) {
    this.pos = new PVector(pos.x, pos.y);
    this.player = player;
    if (this.player == true) { 
      this.vel = 20;
    }
    if (this.player == false) { 
      this.vel = (level*0.1)+5;
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
      pos.y -= vel;
    }
    if (player == false) {
      pos.y += vel;
    }
  }

  void update() {
    render();
    move();
  }
}
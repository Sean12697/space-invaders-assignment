class Collision {
  boolean crash;
  int i;
  int j;
  
  Collision (boolean crash, int i, int j) {
   this.crash = crash;
   this.i = i;
   this.j = j;
  }
  
  Collision (int i, int j) {
   this.i = i;
   this.j = j;
  }
  
  Collision () {
   //Blank constructer created to initate a blank
  }
}
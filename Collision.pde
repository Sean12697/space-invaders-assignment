class Collision extends twoDimensionArrayIndex { //Inheritance
  boolean crash;

  Collision (boolean crash, int i, int j) {
    super(i, j);
    this.crash = crash;
  }
}
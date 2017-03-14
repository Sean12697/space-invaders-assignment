class Collision extends twoDimensionArrayIndex {
  boolean crash;

  Collision (boolean crash, int i, int j) {
    super(i, j);
    this.crash = crash;
  }

  Collision (int i, int j) {
    super(i, j);
  }
}
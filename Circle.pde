class Circle {
  color col;
  PVector pos;
  float size;

  Circle(color _col, PVector _pos, float _size) {
    col = _col;
    pos = _pos.copy();
    size = _size;
  }

  void draw() {
    stroke(col);
    fill(col);
    circle(pos.x, pos.y, size);
  }
}

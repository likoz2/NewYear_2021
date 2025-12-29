color[] colsF = new color[]{color(250, 25, 0), color(255, 75, 0), color(255, 125, 0), color(255, 175, 0)};
color[] colsE = new color[]{color(46, 116, 255), color(46, 227, 255), color(8, 255, 78), color(255, 248, 28), color(237, 158, 12), color(255, 64, 0), color(255, 0, 0), color(255, 0, 115)};

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float lifeSpeed;
  int colType;
  int type;
  float size;
  boolean canLock;
  boolean locked;

  Particle(PVector l, int _type) {
    type = _type;
    if (type == FUEL) {
      acceleration = new PVector(0, 0.15);
      velocity = new PVector(random(-1, 1), random(-2, 0));
      position = l.copy();
      lifespan = 255.0;
      colType = int(random(0, colsF.length));
      lifeSpeed = 12;
      size = random(6, 10)*1.3;
    } else if (type == EXP) {
      float angle = random(-PI, PI);
      float speed = random(7, 13);
      float x = cos(angle)*speed;
      float y = sin(angle)*speed;
      velocity = new PVector(x, y);
      acceleration = new PVector(-velocity.x/90/random(2.5, 3.5), -velocity.y/90/random(2.5, 3.5)+0.04);
      position = l.copy();
      lifespan = 255.0;
      colType = int(random(0, colsE.length));
      size = random(6, 10)*1.3;
      lifeSpeed = size/random(1.5, 2);
      canLock = random(0, 1) < 0.6;
    }
  }

  void run() {
    update();
    draw();
    tryLock();
  }

  void tryLock() {
    if (!canLock || locked) {
      return;
    }
    if (random(0, 1) > 0.05) {
      return;
    }

    if (lifespan > 100) {
      PVector ppos = position.copy();
      int index = int(int(ppos.x) + int(ppos.y)*width);
      if (index > 0 && index < width*height) {
        if (pix[index] == -1) {
          circles.add(new Circle(colsE[colType], new PVector(index%width, index/width), size));
          locked = true;
        }
      }
    }
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= lifeSpeed;
    if (lifespan < 100) {
      if (type == EXP) {
        if (position.x < 0 || position.x > width || position.y < 0 || position.y > 700) {
          return;
        }
        if (random(0, 1) < 0.0005) {
          Rocket r = new Rocket(new PVector(position.x, position.y), 0);
          addRockets.add(r);
          r.explodeAt = 700;
        }
      }
    }
  }

  // Method to display
  void draw() {
    color c = color(255, 0, 0);
    if (type == 0) {
      c = colsF[colType];
    } else if (type == 1) {
      c = colsE[colType];
    }
    stroke(c, lifespan);
    fill(c, lifespan);
    circle(position.x, position.y, size);
    if (type == 1) {
      for (int i = 0; i < 4; i++) {
        stroke(c, aboveZero(lifespan - i * 10));
        fill(c, aboveZero(lifespan - i * 10));
        circle(position.x - acceleration.x*i*70, position.y - (acceleration.y-0.04)*i*80, size);
      }
    }
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 50.0) {
      return true;
    } else {
      return false;
    }
  }
}

int FUEL = 0;
int EXP = 1;

class Rocket {
  ParticleSystem ps;
  boolean exploded = false;
  PVector pos;
  PVector vel;
  PVector acc;
  float explodeAt;
  float explodedAt;
  int lockedAmount = 0;
  int onGroundForXFrames;

  Rocket(PVector _pos, int ogfxf) {
    pos = _pos.copy();
    ps = new ParticleSystem(pos.copy());
    vel = new PVector(random(-0.01, 0.01), random(-0.2, -0.1));
    acc = new PVector(random(-0.07, 0.07), random(-0.8, -0.4));
    explodeAt = random(150, height-300);
    onGroundForXFrames = ogfxf;
  }

  void draw() {
    update();
    ps();
  }

  void ps() {
    // not exploded or is exploding
    if (!exploded) {
      ps.addParticle(FUEL);
      ps.addParticle(FUEL);
      ps.addParticle(FUEL);
      ps.addParticle(FUEL);
    }
    if (exploded && explodedAt + 100 > millis()) {
      for (int i = 0; i < 21; i++) {
        ps.addParticle(EXP);
      }
    }
    ps.run();
  }

  void update() {
    if (onGroundForXFrames > 0) {
      onGroundForXFrames--;
      vel.add(acc);
    } else if (!exploded) {
      vel.add(acc);
      pos.add(vel);
      ps.pos = pos.copy();
      if (pos.y < explodeAt) {
        explode();
      }
    } else if (exploded) {
      // eploded
      //tryLockP(); // no more trying here, moved to Particle

      // expired
      if (ps.particles.size() == 0) {
        remRockets.add(this);
      }
    }
  }

  void tryLockP() {
    if (lockedAmount <= 20) {
      if (ps != null) {
        if (ps.particles != null) {
          if (ps.particles.size() > 0) {
            Particle p = ps.particles.get(int(random(0, ps.particles.size())));
            if (p.lifespan > 75) {
              PVector ppos = p.position.copy();
              int index = int(int(ppos.x) + int(ppos.y)*1920);
              if (index > 0 && index < 2073600) {
                if (pix[index] == -1) {
                  //println("(" + index%1920 + " " + index/1920 + ")" + "   " + "(" + ppos.x + " " + ppos.y + ")");
                  //circles.add(new Circle(colsE[p.colType], ppos.copy(), p.size));
                  circles.add(new Circle(colsE[p.colType], new PVector(index%1920, index/1920), p.size));
                }
              }
            }
          }
        }
      }
    }
  }

  void explode() {
    exploded = true;
    explodedAt = millis();
  }
}

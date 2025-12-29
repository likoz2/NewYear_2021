class ParticleSystem {
  ArrayList<Particle> particles;
  PVector pos;

  ParticleSystem(PVector position) {
    pos = position.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticle(int _type) {
    particles.add(new Particle(PVector.add(pos, new PVector(random(-5, 5), random(-5, 5))), _type));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}

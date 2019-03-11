class Particle3DSystem { 
  PVector pos;
  ArrayList<Particle3D> cles;

  Particle3DSystem(PVector p) {

    cles = new ArrayList<Particle3D>(); 
    pos = new PVector(p.x, p.y, p.z);
  }
  void steerTo(PVector p) {
    PVector target = p.copy();
    for (int i = 0; i < cles.size(); i++) {  
      cles.get(i).steerTo(p);
    }
  }
  void steerTo(PVector p, float strength) {
    PVector target = p.copy();
    for (int i = 0; i < cles.size(); i++) { 
      cles.get(i).steerTo(p, strength);
    }
  }

  void attractTo(PVector p, int direction) {
    PVector target = p.copy();
    for (int i = 0; i < cles.size(); i++) {
      cles.get(i).attractTo(p, direction);
    }
  }

  void addParticles(int addcnt) {
    for (int i = 0; i < addcnt; i++) {
      cles.add(new Particle3D(new PVector(random(-10, 10), random(-10, 10), random(-10, 10))));
    }
  }

  void update() {
    for (int i = 0; i < cles.size(); i++) {
      cles.get(i).update();
    }
  }


  void show() {
    pushMatrix();
    for (int i = 0; i < cles.size(); i++) { 
      //cles[i].steerTo(tg); 
      //cles[i].attractTo(tg, attractForceDir); // 1:rebel; -1:attract 

      cles.get(i).show();
    }
    popMatrix();
  }
}

class rayParticleSystem extends Particle3DSystem {
  ArrayList<rayParticle> raycles = new ArrayList<rayParticle>();

  rayParticleSystem(PVector p) {
    super(p); 
  }


  void emit(int addcnt, PVector loc, PVector _tar) {
    for (int i = 0; i < addcnt; i++) {
      rayParticle newcle = new rayParticle(new PVector(
      loc.x,  loc.y,  loc.z));
      newcle.setTarget(_tar);
      raycles.add(newcle);
    }
  }

  void update() {
    for (int i = 0; i <raycles.size(); i++) {
      raycles.get(i).update();
      if (raycles.get(i).isDead()) {
        raycles.remove(i);
        i--;
      }
    }
  }
  void show() {
    pushMatrix();
    for (int i = 0; i < raycles.size(); i++) { 
      //cles[i].steerTo(tg); 
      //cles[i].attractTo(tg, attractForceDir); // 1:rebel; -1:attract 

      raycles.get(i).show();
    }
    popMatrix();
  }
}

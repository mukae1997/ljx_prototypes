class Mover {

  PVector vel, pos, acc;
  float maxspeed;
  ArrayList<PVector> history;


  Mover(PVector p) {
    pos = p.copy();
    vel = new PVector();
    acc = new PVector(0, 0, 0);
    maxspeed = random(3, 20);
    history = new ArrayList<PVector>();
  }

  void edge() {
    if (pos.x > width) pos.x = 0;
    if (pos.x < 0) pos.x = width;
    if (pos.y > height) pos.y = 0;
    if (pos.y < 0) pos.y = height;
  }

  void update() {
    vel.limit(maxspeed).add(acc);
    pos.add(vel);
    acc.mult(0);
    history.add(0, pos.copy());
    int maxsize = 1;
    if (history.size() > maxsize) {
      history.remove(floor(maxsize));
    }
  }

  void steerTo(PVector tg) {
    PVector steer = tg.copy();
    float steerforce = 3.0 + random(-1.2, 0.9);
    steer.sub(pos).sub(vel).normalize().mult(steerforce);
    acc.add(steer);
  }
  void steerTo(PVector tg, float s) {
    PVector steer = tg.copy();
    float steerforce = s;
    steer.sub(pos).sub(vel).normalize().mult(steerforce);
    acc.add(steer);
  }
  void show() { 
    for (int i = 0; i < history.size(); i++ ) {
      pushMatrix();

      translate(history.get(i).x, history.get(i).y);

      strokeWeight(13 * map(i, 0, history.size(), 1, 0.1));
      stroke(255, 0, 0, map(i, 0, history.size(), 255, 6));
      noFill();
      point(0, 0, 0);

      popMatrix();
    }
  }
}

class MM extends Mover {
  ArrayList<SM> sms = new ArrayList<SM>(); 
  MM(PVector p, int c) {
    super(p);
    for (int i = 0; i < c; i++) {
      sms.add(new SM(PVector.add(p, PVector.random2D().mult(100) )));
    }
  }
  void updateSlaves() {
    for (SM s : sms) {
      s.steerToMaster(this);

      //for (SM os : sms) {
      //  if (s != os) {
      //    s.runAwayFrom(os);
      //  }
      //}
      s.update();
    }
  }
  void update() {
    super.update();
    updateSlaves();
  }
  void show() {
    super.show();
    for (SM s : sms) {
      s.show();
    }
  }
}

class SM extends Mover {
  float minDist;
  float seed;
  SM(PVector p) {
    super(p);
    seed = random(0.5);
    minDist = random(100, width*0.6);
  }
  void steerToMaster(Mover m) {
    if (PVector.dist(pos, m.pos) > minDist)
      pos = PVector.lerp(pos, m.pos, seed);
  }
  void runAwayFrom(SM s) {
    if (PVector.dist(pos, s.pos) < 100 * seed) {
      pos = PVector.lerp(pos, s.pos, -seed);
    }
  }
}

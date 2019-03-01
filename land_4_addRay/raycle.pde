class Particle3D {

  PVector vel, pos, acc;
  float maxspeed;
  ArrayList<PVector> history;




  Particle3D(PVector p) {
    pos = p.copy();
    vel = new PVector(random(-10, 10), random(-10, 10), random(-10, 10));
    acc = new PVector(0, 0, 0);
    maxspeed = random(3, 20);
    history = new ArrayList<PVector>();
  }
  void steerTo(PVector tg) {
    PVector steer = tg.copy();
    float steerforce = 3.0 + random(-1.2, 0.9);
    steer.sub(pos).sub(vel).normalize().mult(steerforce);
    acc.add(steer);
  }

  void applyForce(PVector f) {
    acc.add(f);
  }

  void steerTo(PVector tg, float steerstrength) {
    PVector steer = tg.copy();
    float steerforce = 3.0 + random(-1.2, 0.9);
    steer.sub(pos).sub(vel).normalize().mult(steerstrength + steerforce);
    acc.add(steer);
  }


  void attractTo(PVector tg, int direction) {
    PVector target = tg.copy();

    PVector force = new PVector(pos.x, pos.y, pos.z);
    float  lowerbound = 0.4; 
    // repel: control the maximum dist particle could go.  larger the bigger.
    float upperbound = 3.5;
    // repel: control how near particle could close to target. smaller the closer.
    float attractforce = map(pos.dist(target), 0, 486, upperbound, lowerbound);
    force.sub(target).normalize().mult(attractforce).mult(direction);
    if (direction == -1) force.mult(0.5);
    acc.add(force);
  }


  void attractTo(PVector tg, int direction, float lb, float ub) {
    PVector target = tg.copy();

    PVector force = new PVector(pos.x, pos.y, pos.z);
    float  lowerbound = lb; 
    // repel: control the maximum dist particle could go.  larger the bigger.
    float upperbound = ub;
    // repel: control how near particle could close to target. smaller the closer.
    float attractforce = map(pos.dist(target), 0, 486, upperbound, lowerbound);
    force.sub(target).normalize().mult(attractforce).mult(direction);
    if (direction == -1) force.mult(0.5);
    acc.add(force);
  }


  void update() {
    maxspeed = 1;
    vel.limit(maxspeed).add(acc);
    pos.add(vel);
    acc.mult(0);
    history.add(0, pos.copy());
    int maxsize = 3;
    if (history.size() > maxsize) {
      history.remove(floor(maxsize));
    }
  }

  void show() { 
    for (int i = 0; i < history.size(); i++ ) {
      pushMatrix();

      translate(history.get(i).x, history.get(i).y, history.get(i).z); 
      strokeWeight(3 * map(i, 0, history.size(), 1, 0.1));
      stroke(255, map(i, 0, history.size(), 218, 6));
      noFill();
      point(0, 0, 0);

      popMatrix();
    }
  }
}

class rayParticle extends Particle3D {
  private PVector target = new PVector();

  float state = 0;
  boolean isDead = false;
  float startTime = 0;
  float lifeSpan = 2.8;
  float angle = 0;
  float angleRate;

  rayParticle(PVector p) {
    super(p);
    angleRate = random(1);

    reset();
  }

  boolean isDead() {
    return isDead;
  }

  void reset() {
    state = 0;
    startTime = millis();
    isDead = false;
  }


  void setTarget(PVector t) {
    target.set(t);
  }

  void update() {

    super.steerTo(target);
    //super.attractTo(target, 1, 1.2, 2.9);

    //super.steerTo(target);

    if (isDead) return ;
    state = (millis() - startTime) * 0.001 / lifeSpan; 
    //if (PVector.dist(pos, target) < 10) {
    //  state = 1.01;
    //}
    isDead = state > 1;
    state = min(state, 1);
    // ----------------------------
    float angfac = 7.0;
    maxspeed = 4;
    //vel.add(new PVector(angfac*sin(angle), angfac* cos(angle)));
    vel.add(acc).limit(maxspeed);
    pos.add(vel); 
    pos.add(new PVector(angfac*sin(angle), angfac* cos(angle)));
    acc.mult(0);
    // ----------------------------
    history.add(0, pos.copy());
    int maxsize = 19;
    if (history.size() > maxsize) {
      history.remove(floor(maxsize));
    }
    // ----------------------------
    angle += angleRate*0.25;
  }
  void show() {
    pushMatrix();
 
    for (int i = 0; i < history.size(); i++ ) { 
      strokeWeight(map(i, 0, history.size(), 2.1, 0.6));
      stroke(255, map(state, 0, 1, map(i, 0, history.size(), 61, 16), 5));

      if (history.size() == 1) {
        pushMatrix();  
        translate(history.get(i).x, history.get(i).y, history.get(i).z);
        point(0, 0, 0);
        popMatrix();
      } else if (history.size()-1 > i) {

        line(history.get(i).x, history.get(i).y, history.get(i).z, 
          history.get(i+1).x, history.get(i+1).y, history.get(i+1).z);
      }
    }
    popMatrix();
  }
}

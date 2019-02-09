class Particle3DSystem { 
  PVector pos;
  ArrayList<Particle3D> cles;
  
  public float BASE_R = 90;

  Particle3DSystem(int _c, PVector p) {

    cles = new ArrayList<Particle3D>();
    for (int i = 0; i < _c; i++) {
      cles.add(new Particle3D(new PVector(random(-100, 100), random(-100, 100), random(-100, 100)),BASE_R));
    }
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

  void addParticles(int addcnt, PVector p) {
    for (int i = 0; i < addcnt; i++) {
      cles.add(new Particle3D(p, BASE_R));
    }
  } 

  void update() {
    for (int i = 0; i < cles.size(); i++) {
      Particle3D p =  cles.get(i);
      p.BASE_R = BASE_R;
      p.update();
      if (p.timer.isDead()) {
        cles.remove(i);
        i--;
      }
    }
  }


  void show(PGraphics2D pg) {

    pg.pushMatrix();
    for (int i = 0; i < cles.size(); i++) { 
      //cles[i].steerTo(tg); 
      //cles[i].attractTo(tg, attractForceDir); // 1:rebel; -1:attract 

      cles.get(i).show(pg);
    }
    pg.popMatrix();
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
class Particle3D {

  PVector vel, pos, acc;
  float maxspeed;
  ArrayList<PVector> history;

  lifeStateTimer timer;

  float BASE_R;

  Particle3D(PVector p, float r) {
    pos = p.copy();
    BASE_R = r;
    vel = new PVector(random(-10, 10), random(-10, 10), random(-10, 10));
    acc = new PVector(0, 0, 0);
    maxspeed = random(2, 4);
    history = new ArrayList<PVector>();

    timer = new lifeStateTimer(5.0);
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
  void edge() {
    if (pos.x > width) pos.x = 0;
    if (pos.x < 0) pos.x = width;
    if (pos.y > height) pos.y = 0;
    if (pos.y < 0) pos.y = height;
  }


  void update() {
    timer.update();

    vel.limit(maxspeed).add(acc);
    //pos.add(vel);
    acc.mult(0);
    history.add(0, pos.copy());
    int maxsize = 1;
    if (history.size() > maxsize) {
      history.remove(floor(maxsize));
    }
  }

  //void show() { 
  //  for (int i = 0; i < history.size(); i++ ) {
  //    pushMatrix();

  //    translate(history.get(i).x, history.get(i).y, history.get(i).z);

  //    // strokeWeight(3 * map(i, 0, history.size(), 1, 0.1));
  //    // stroke(255, map(i, 0, history.size(), 218, 6));
  //    // noFill();
  //    // point(0, 0, 0);
  //    float r = 100*max(0.1,1-timer.state);
  //    fill(0, 70);
  //    ellipse(0, 0, r, r);

  //    popMatrix();
  //  }
  //}

  void show() {  
    pushMatrix();

    translate(pos.x, pos.y);

    // strokeWeight(3 * map(i, 0, history.size(), 1, 0.1));
    // stroke(255, map(i, 0, history.size(), 218, 6));
    // noFill();
    // point(0, 0, 0);
    float r = BASE_R*max(0.1, 1-timer.state);
    fill(0, 180);
    ellipse(0, 0, r, r);

    popMatrix();
  }


  //void show(PGraphics2D pg) { 
  //  try {
  //    for (int i = 0; i < history.size(); i++ ) {
  //      pg.pushMatrix();

  //      pg.translate(history.get(i).x, history.get(i).y);

  //      // strokeWeight(3 * map(i, 0, history.size(), 1, 0.1));
  //      // stroke(255, map(i, 0, history.size(), 218, 6));
  //      // noFill();
  //      // point(0, 0, 0);
  //      float r = 100*(1-timer.state) + 2;
  //      pg.fill(64);
  //      pg.ellipse(0, 0, r, r);

  //      pg.popMatrix();
  //    }
  //  } 
  //  catch (Exception e) {
  //    println(e);
  //  }
  //}


  void show(PGraphics2D pg) { 
    try {

      pg.pushMatrix(); 

      pg.translate(pos.x, pos.y);

      // strokeWeight(3 * map(i, 0, history.size(), 1, 0.1));
      // stroke(255, map(i, 0, history.size(), 218, 6));
      // noFill();
      // point(0, 0, 0);
      float r = BASE_R * max(0.1, 1-timer.state) + 2;
      pg.fill(64);
      pg.ellipse(0, 0, r, r);


      pg.popMatrix();
    } 
    catch (Exception e) {
      println(e);
    }
  }
}

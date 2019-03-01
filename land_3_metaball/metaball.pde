int METABALL_ATTR_LEN = 4; // don't modify


int METABALL_NUM = 50;  // MUST modify 'metaballFrag.glsl' simultaneously!!



class MetaballParticleSystem {
  ArrayList<MetaballParticle> cles; 

  float[] mbs = new float[METABALL_NUM * METABALL_ATTR_LEN];

  int ptr = 0;
  MetaballParticleSystem( ) { 
    cles = new ArrayList<MetaballParticle>();


    for (int i = 0; i < METABALL_NUM; i++) {
      cles.add(new MetaballParticle());
    }
  }
  MetaballParticle getNewCle() {

    for (int i = 0; i < METABALL_NUM; i++) {
      if (cles.get(i).isDead()) return cles.get(i);
    }
    return cles.get(ptr++%cles.size());
  }

  void update() {
    for (int i = 0; i < cles.size(); i++) {
      cles.get(i).update();
    }

    if (true) {
      MetaballParticle mp = getNewCle();
      mp.loc.set(mouseX, mouseY);
      mp.timer.reset();
    }

    for (int i = 0; i < METABALL_NUM; i++) {
      mbs[i*METABALL_ATTR_LEN] = 1.0f; 
      mbs[i*METABALL_ATTR_LEN + 1] = 1.0f; 
      mbs[i*METABALL_ATTR_LEN] = cles.get(i).loc.x * 1.0f; 
      mbs[i*METABALL_ATTR_LEN + 1] = cles.get(i).loc.y * 1.0f; 
      mbs[i*METABALL_ATTR_LEN + 2] = cles.get(i).radious;
      mbs[i*METABALL_ATTR_LEN + 3] = cles.get(i).timer.state;
    } 


    metaballShader.set("WIDTH", width * 1.0f); 
    metaballShader.set("HEIGHT", height * 1.0f);  
    metaballShader.set("metaballs", mbs, METABALL_ATTR_LEN); 
    metaballShader.set("a", 2.1);
  }
  void render(PGraphics pg) {
    // gpu stuff

    pg.resetShader();
    pg.shader(metaballShader); 
    //pg.fill(0,0);
    pg.beginShape(QUADS);
    pg.vertex(0, 0);
    pg.vertex(width, 0);
    pg.vertex(width, height);
    pg.vertex(0, height);
    pg.endShape();
    pg.resetShader();
  }
}

class MetaballParticle {
  lifeStateTimer timer;
  float radious;
  PVector loc, vel;
  float _lifespan_ = 1.0;

  float RADIUS_UPPER_BOUND = 20;

  MetaballParticle() {
    timer = new lifeStateTimer(_lifespan_);
    radious = random(RADIUS_UPPER_BOUND/3, RADIUS_UPPER_BOUND);
    loc = new PVector(0, 0);
    float velSize = random(2, 5);
    float velAng = random(TWO_PI);
    vel = new PVector(velSize * cos(velAng), velSize * sin(velAng));
  }

  MetaballParticle(float x, float y) {
    timer = new lifeStateTimer(_lifespan_);
    radious = random(RADIUS_UPPER_BOUND/3, RADIUS_UPPER_BOUND);
    loc = new PVector(x, y);
    float velSize = random(2, 5);
    float velAng = random(TWO_PI);
    vel = new PVector(velSize * cos(velAng), velSize * sin(velAng));
  }

  void update() {
    timer.update();
    loc.add(vel );
    if (loc.x < radious) {
      vel.x *= -1;
      loc.x += vel.x;
    }
    if (loc.x >= width - radious) {
      vel.x *= -1;
      loc.x += vel.x;
    }
    if (loc.y < radious) {
      vel.y *= -1;
      loc.y += vel.y;
    }
    if (loc.y >= height - radious) {
      vel.y *= -1;
      loc.y += vel.y;
    }
    vel.limit(2);
  }

  void update(float dt) {

    timer.update();
    loc.add(vel.copy().mult(dt));
    if (loc.x < radious) {
      vel.x *= -1;
      loc.x += vel.x;
    }
    if (loc.x >= width - radious) {
      vel.x *= -1;
      loc.x += vel.x;
    }
    if (loc.y < radious) {
      vel.y *= -1;
      loc.y += vel.y;
    }
    if (loc.y >= height - radious) {
      vel.y *= -1;
      loc.y += vel.y;
    }
  }

  boolean isDead() {

    return timer.isDead();
  }

  void draw() {
    pushStyle();
    noFill();
    strokeWeight(2.0);
    stroke(255);
    ellipse(loc.x, loc.y, 5, 5);
    popStyle();
  }
}

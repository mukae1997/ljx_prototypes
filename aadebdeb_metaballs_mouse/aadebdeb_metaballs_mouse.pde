/**
 * metaballs (Marching Squares algorithm)
 *
 * @author aa_debdeb
 * @date 2016/06/25
 */

int num = 5; // number of atom-blobs
ArrayList<Particle> particles;
int cellNum = 80;
float cellSize = 10;
float[][] cells;

void setup() {
  size(800, 500);
  cells = new float[cellNum + 1][cellNum + 1];
  particles = new ArrayList<Particle>();
  for (int i = 0; i < num; i++) {
    particles.add(new Particle());
  }
  noFill();
  stroke(255, 255, 240);
  strokeWeight(7);
}

void draw() {
  float dt = 0.17; // 程序更新速度 playwithit!
  background(128, 128, 120);
  for (int y = 0; y < cellNum + 1; y++) {
    for (int x = 0; x < cellNum + 1; x++) {
      PVector c = new PVector(x * cellSize, y * cellSize);

      //debug

      pushStyle();
      noFill();
      strokeWeight(1.0);
      stroke(#3d5d99);
      ellipse(c.x, c.y, 10, 10);
      popStyle();

      // c : grid point position
      cells[x][y] = 0.0;
      for (Particle p : particles) {
        float fac = p.radious / PVector.sub(c, p.loc).mag();
        fac *= sin(p.timer.state * PI); // test
        cells[x][y] += fac;
      }
    }
  }
  boolean drawCurveShape = true, drawGridLike = true; //playwithit!
  // marching square implementation
  for (int y = 0; y < cellNum; y++) {
    for (int x = 0; x < cellNum; x++) {
      PVector c = new PVector(cellSize * x, cellSize * y);
      int state = int((cells[x][y + 1] >= 1 ? 1: 0)
        + pow(cells[x + 1][y + 1] >= 1 ? 2: 0, 1)
        + pow(cells[x + 1][y] >= 1 ? 2: 0, 2)
        + pow(cells[x][y] >= 1 ? 2: 0, 3));


      float halfSize = cellSize / 2.0;

      strokeWeight(1.6);

      if (drawCurveShape) {

        float x1, y1, x2, y2; 
        if (state == 1 || state == 14) { 

          x1 = c.x;
          y1 = c.y + cellSize * ((1.0 - cells[x][y]) / (cells[x][y + 1] - cells[x][y]));
          x2 = c.x + cellSize * ((1.0 - cells[x][y + 1]) / (cells[x + 1][y + 1] - cells[x][y + 1]));
          y2 = c.y + cellSize;
          line(x1, y1, x2, y2);
        } else if (state == 2 || state == 13) { 
          x1 = c.x + cellSize;
          y1 = c.y + cellSize * ((1.0 - cells[x + 1][y]) / (cells[x + 1][y + 1] - cells[x + 1][y]));
          x2 = c.x + cellSize * ((1.0 - cells[x][y + 1]) / (cells[x + 1][y + 1] - cells[x][y + 1]));
          y2 = c.y + cellSize;
          line(x1, y1, x2, y2);
        } else if (state == 3 || state == 12) { 
          x1 = c.x;
          y1 = c.y + cellSize * ((1.0 - cells[x][y]) / (cells[x][y + 1] - cells[x][y]));
          x2 = c.x + cellSize;
          y2 = c.y + cellSize * ((1.0 - cells[x + 1][y]) / (cells[x + 1][y + 1] - cells[x + 1][y]));
          line(x1, y1, x2, y2);
        } else if (state == 4 || state == 11) {  
          x1 = c.x + cellSize * ((1.0 - cells[x][y]) / (cells[x + 1][y] - cells[x][y]));
          y1 = c.y;
          x2 = c.x + cellSize;
          y2 = c.y + cellSize * ((1.0 - cells[x + 1][y]) / (cells[x + 1][y + 1] - cells[x + 1][y]));
          line(x1, y1, x2, y2);
        } else if (state == 5) { 
          x1 = c.x + cellSize * ((1.0 - cells[x][y]) / (cells[x + 1][y] - cells[x][y]));
          y1 = c.y;
          x2 = c.x;
          y2 = c.y + cellSize * ((1.0 - cells[x][y]) / (cells[x][y + 1] - cells[x][y]));
          line(x1, y1, x2, y2);  
          x1 = c.x + cellSize;
          y1 = c.y + cellSize * ((1.0 - cells[x + 1][y]) / (cells[x + 1][y + 1] - cells[x + 1][y]));
          x2 = c.x + cellSize * ((1.0 - cells[x][y + 1]) / (cells[x + 1][y + 1] - cells[x][y + 1]));
          y2 = c.y + cellSize;
          line(x1, y1, x2, y2);
        } else if (state == 6 || state == 9) { 
          x1 = c.x + cellSize * ((1.0 - cells[x][y]) / (cells[x + 1][y] - cells[x][y]));
          y1 = c.y;
          x2 = c.x + cellSize * ((1.0 - cells[x][y + 1]) / (cells[x + 1][y + 1] - cells[x][y + 1]));
          y2 = c.y + cellSize;
          line(x1, y1, x2, y2);
        } else if (state == 7 || state == 8) {
          x1 = c.x + cellSize * ((1.0 - cells[x][y]) / (cells[x + 1][y] - cells[x][y]));
          y1 = c.y;
          x2 = c.x;
          y2 = c.y + cellSize * ((1.0 - cells[x][y]) / (cells[x][y + 1] - cells[x][y]));
          line(x1, y1, x2, y2);
        } else if (state == 10) {
          x1 = c.x + cellSize * ((1.0 - cells[x][y]) / (cells[x + 1][y] - cells[x][y]));
          y1 = c.y;
          x2 = c.x + cellSize;
          y2 = c.y + cellSize * ((1.0 - cells[x + 1][y]) / (cells[x + 1][y + 1] - cells[x + 1][y]));
          line(x1, y1, x2, y2);  
          x1 = c.x;
          y1 = c.y + cellSize * ((1.0 - cells[x][y]) / (cells[x][y + 1] - cells[x][y]));
          x2 = c.x + cellSize * ((1.0 - cells[x][y + 1]) / (cells[x + 1][y + 1] - cells[x][y + 1]));
          y2 = c.y + cellSize;
          line(x1, y1, x2, y2);
        }
      }
     if (drawGridLike){
        // draw according to grid

        if (state == 0) {
        } else if (state == 1) {
          line(c.x, c.y + halfSize, c.x + halfSize, c.y + cellSize);
        } else if (state == 2) {
          line(c.x + cellSize, c.y + halfSize, c.x + halfSize, c.y + cellSize);
        } else if (state == 3) {
          line(c.x, c.y + halfSize, c.x + cellSize, c.y + halfSize);
        } else if (state == 4) {
          line(c.x + halfSize, c.y, c.x + cellSize, c.y + halfSize);
        } else if (state == 5) {
          line(c.x + halfSize, c.y, c.x, c.y + halfSize);
          line(c.x + cellSize, c.y + halfSize, c.x + halfSize, c.y + cellSize);
        } else if (state == 6) {
          line(c.x + halfSize, c.y, c.x + halfSize, c.y + cellSize);
        } else if (state == 7) {
          line(c.x + halfSize, c.y, c.x, c.y + halfSize);
        } else if (state == 8) {
          line(c.x + halfSize, c.y, c.x, c.y + halfSize);
        } else if (state == 9) {
          line(c.x + halfSize, c.y, c.x + halfSize, c.y + cellSize);
        } else if (state == 10) {
          line(c.x + halfSize, c.y, c.x + cellSize, c.y + halfSize);
          line(c.x, c.y + halfSize, c.x + halfSize, cellSize);
        } else if (state == 11) {
          line(c.x + halfSize, c.y, c.x + cellSize, c.y + halfSize);
        } else if (state == 12) {
          line(c.x, c.y + halfSize, c.x + cellSize, c.y + halfSize);
        } else if (state == 13) {
          line(c.x + cellSize, c.y + halfSize, c.x + halfSize, c.y + cellSize);
        } else if (state == 14) {
          line(c.x, c.y + halfSize, c.x + halfSize, c.y + cellSize);
        }
      }
    }
  }
  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    p.update(dt);
    if (p.isDead()) {
      particles.remove(i);
      i--;
      continue;
    }
    p.draw();
  }
}

class Particle {
  lifeStateTimer timer;
  float radious;// playwithit!
  PVector loc, vel;
  float _lifespan_ = 8.0; //playwithit!
  Particle() {
    timer = new lifeStateTimer(_lifespan_);
    radious = random(10, 20);
    loc = new PVector(random(radious, width - radious), random(radious, height - radious));
    float velSize = random(2, 5);
    float velAng = random(TWO_PI);
    vel = new PVector(velSize * cos(velAng), velSize * sin(velAng));
  }

  Particle(float x, float y) {
    timer = new lifeStateTimer(_lifespan_);
    radious = random(10, 20);
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

void mouseReleased() {
  particles.add(new Particle(mouseX, mouseY));
}

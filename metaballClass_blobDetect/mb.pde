/**
 * metaballs (Marching Squares algorithm)
 *
 * @author aa_debdeb
 * @date 2016/06/25
 */
class MetaBallTest {
  int num = 10; // number of atom-blobs
  ArrayList<MetaballParticle> particles;
  int cellNum_w, cellNum_h;
  float cellSize = 20;
  float[][] cells;

  PApplet PAppletContext;
  
  
  MetaBallTest(PApplet p) {
    PAppletContext = p;
    cellNum_w = (int)(width / cellSize);
    cellNum_h = (int)(height / cellSize);
    cells = new float[cellNum_w + 1][cellNum_h + 1];
    particles = new ArrayList<MetaballParticle>();
    for (int i = 0; i < num; i++) {
      particles.add(new MetaballParticle());
    }
    noFill();
    stroke(255, 255, 240);
    strokeWeight(7);
  }



  void show() {
    show((PGraphics2D)PAppletContext.g);
  }


  void show(PGraphics2D pg) {
    float dt = 0.17; // 程序更新速度
    //background(128, 128, 120);
    for (int y = 0; y < cellNum_h + 1; y++) {
      for (int x = 0; x < cellNum_w + 1; x++) {
        PVector c = new PVector(x * cellSize, y * cellSize);

        //debug -- grid circles
 
        //pg.pushStyle();
        //pg.noFill();
        //pg.strokeWeight(1.0);
        //pg.stroke(#3d5d99);
        //pg.ellipse(c.x, c.y, 10, 10);
        //pg.popStyle();

        // c : grid point position
        cells[x][y] = 0.0;
        for (MetaballParticle p : particles) {
          float fac = p.radious / PVector.sub(c, p.loc).mag();
          //fac *= sin(p.timer.state * PI); // test
          cells[x][y] += fac;
        }
      }
    }
    boolean drawCurveShape = true, drawGridLike = false;
    // marching square implementation
    for (int y = 0; y < cellNum_h; y++) {
      for (int x = 0; x < cellNum_w; x++) {
        PVector c = new PVector(cellSize * x, cellSize * y);
        int state = int((cells[x][y + 1] >= 1 ? 1: 0)
          + pow(cells[x + 1][y + 1] >= 1 ? 2: 0, 1)
          + pow(cells[x + 1][y] >= 1 ? 2: 0, 2)
          + pow(cells[x][y] >= 1 ? 2: 0, 3));


        float halfSize = cellSize / 2.0;

        pg.strokeWeight(1.6);
        pg.stroke(255);

        if (drawCurveShape) {

          float x1, y1, x2, y2; 
          if (state == 1 || state == 14) { 

            x1 = c.x;
            y1 = c.y + cellSize * ((1.0 - cells[x][y]) / (cells[x][y + 1] - cells[x][y]));
            x2 = c.x + cellSize * ((1.0 - cells[x][y + 1]) / (cells[x + 1][y + 1] - cells[x][y + 1]));
            y2 = c.y + cellSize;
            pg.line(x1, y1, x2, y2);
          } else if (state == 2 || state == 13) { 
            x1 = c.x + cellSize;
            y1 = c.y + cellSize * ((1.0 - cells[x + 1][y]) / (cells[x + 1][y + 1] - cells[x + 1][y]));
            x2 = c.x + cellSize * ((1.0 - cells[x][y + 1]) / (cells[x + 1][y + 1] - cells[x][y + 1]));
            y2 = c.y + cellSize;
            pg.line(x1, y1, x2, y2);
          } else if (state == 3 || state == 12) { 
            x1 = c.x;
            y1 = c.y + cellSize * ((1.0 - cells[x][y]) / (cells[x][y + 1] - cells[x][y]));
            x2 = c.x + cellSize;
            y2 = c.y + cellSize * ((1.0 - cells[x + 1][y]) / (cells[x + 1][y + 1] - cells[x + 1][y]));
            pg.line(x1, y1, x2, y2);
          } else if (state == 4 || state == 11) {  
            x1 = c.x + cellSize * ((1.0 - cells[x][y]) / (cells[x + 1][y] - cells[x][y]));
            y1 = c.y;
            x2 = c.x + cellSize;
            y2 = c.y + cellSize * ((1.0 - cells[x + 1][y]) / (cells[x + 1][y + 1] - cells[x + 1][y]));
            pg.line(x1, y1, x2, y2);
          } else if (state == 5) { 
            x1 = c.x + cellSize * ((1.0 - cells[x][y]) / (cells[x + 1][y] - cells[x][y]));
            y1 = c.y;
            x2 = c.x;
            y2 = c.y + cellSize * ((1.0 - cells[x][y]) / (cells[x][y + 1] - cells[x][y]));
            pg.line(x1, y1, x2, y2);  
            x1 = c.x + cellSize;
            y1 = c.y + cellSize * ((1.0 - cells[x + 1][y]) / (cells[x + 1][y + 1] - cells[x + 1][y]));
            x2 = c.x + cellSize * ((1.0 - cells[x][y + 1]) / (cells[x + 1][y + 1] - cells[x][y + 1]));
            y2 = c.y + cellSize;
            pg.line(x1, y1, x2, y2);
          } else if (state == 6 || state == 9) { 
            x1 = c.x + cellSize * ((1.0 - cells[x][y]) / (cells[x + 1][y] - cells[x][y]));
            y1 = c.y;
            x2 = c.x + cellSize * ((1.0 - cells[x][y + 1]) / (cells[x + 1][y + 1] - cells[x][y + 1]));
            y2 = c.y + cellSize;
            pg.line(x1, y1, x2, y2);
          } else if (state == 7 || state == 8) {
            x1 = c.x + cellSize * ((1.0 - cells[x][y]) / (cells[x + 1][y] - cells[x][y]));
            y1 = c.y;
            x2 = c.x;
            y2 = c.y + cellSize * ((1.0 - cells[x][y]) / (cells[x][y + 1] - cells[x][y]));
            pg.line(x1, y1, x2, y2);
          } else if (state == 10) {
            x1 = c.x + cellSize * ((1.0 - cells[x][y]) / (cells[x + 1][y] - cells[x][y]));
            y1 = c.y;
            x2 = c.x + cellSize;
            y2 = c.y + cellSize * ((1.0 - cells[x + 1][y]) / (cells[x + 1][y + 1] - cells[x + 1][y]));
            pg.line(x1, y1, x2, y2);  
            x1 = c.x;
            y1 = c.y + cellSize * ((1.0 - cells[x][y]) / (cells[x][y + 1] - cells[x][y]));
            x2 = c.x + cellSize * ((1.0 - cells[x][y + 1]) / (cells[x + 1][y + 1] - cells[x][y + 1]));
            y2 = c.y + cellSize;
            pg.line(x1, y1, x2, y2);
          }
        }
        if (drawGridLike) {
          // draw according to grid

          if (state == 0) {
          } else if (state == 1) {
            pg.line(c.x, c.y + halfSize, c.x + halfSize, c.y + cellSize);
          } else if (state == 2) {
            pg.line(c.x + cellSize, c.y + halfSize, c.x + halfSize, c.y + cellSize);
          } else if (state == 3) {
            pg.line(c.x, c.y + halfSize, c.x + cellSize, c.y + halfSize);
          } else if (state == 4) {
            pg.line(c.x + halfSize, c.y, c.x + cellSize, c.y + halfSize);
          } else if (state == 5) {
            pg.line(c.x + halfSize, c.y, c.x, c.y + halfSize);
            pg.line(c.x + cellSize, c.y + halfSize, c.x + halfSize, c.y + cellSize);
          } else if (state == 6) {
            pg.line(c.x + halfSize, c.y, c.x + halfSize, c.y + cellSize);
          } else if (state == 7) {
            pg.line(c.x + halfSize, c.y, c.x, c.y + halfSize);
          } else if (state == 8) {
            pg.line(c.x + halfSize, c.y, c.x, c.y + halfSize);
          } else if (state == 9) {
            pg.line(c.x + halfSize, c.y, c.x + halfSize, c.y + cellSize);
          } else if (state == 10) {
            pg.line(c.x + halfSize, c.y, c.x + cellSize, c.y + halfSize);
            pg.line(c.x, c.y + halfSize, c.x + halfSize, cellSize);
          } else if (state == 11) {
            pg.line(c.x + halfSize, c.y, c.x + cellSize, c.y + halfSize);
          } else if (state == 12) {
            pg.line(c.x, c.y + halfSize, c.x + cellSize, c.y + halfSize);
          } else if (state == 13) {
            pg.line(c.x + cellSize, c.y + halfSize, c.x + halfSize, c.y + cellSize);
          } else if (state == 14) {
            pg.line(c.x, c.y + halfSize, c.x + halfSize, c.y + cellSize);
          }
        }
      }
    }
    for (int i = 0; i < particles.size(); i++) {
      MetaballParticle p = particles.get(i);
      p.update(dt);
      if (p.isDead()) {
        particles.remove(i);
        i--;
        continue;
      }
      //p.draw();
    }
  }
}

class MetaballParticle {
  lifeStateTimer timer;
  float radious;
  PVector loc, vel;
  float _lifespan_ = 8.0;
  MetaballParticle() {
    timer = new lifeStateTimer(_lifespan_);
    radious = random(10, 20);
    loc = new PVector(random(radious, width - radious), random(radious, height - radious));
    float velSize = random(2, 5);
    float velAng = random(TWO_PI);
    vel = new PVector(velSize * cos(velAng), velSize * sin(velAng));
  }

  MetaballParticle(float x, float y) {
    timer = new lifeStateTimer(_lifespan_);
    radious = random(10, 20);
    loc = new PVector(x, y);
    float velSize = random(2, 5);
    float velAng = random(TWO_PI);
    vel = new PVector(velSize * cos(velAng), velSize * sin(velAng));
  }

  void update() {
    //timer.update();
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

    //timer.update();
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
  //mb.particles.add(new MetaballParticle(mouseX, mouseY));
}

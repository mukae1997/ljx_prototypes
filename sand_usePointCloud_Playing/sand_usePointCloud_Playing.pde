// 按空格切换配色
// 按 I 切换绘制 sprite/point
//加了轨迹效果 按C切换

import traer.physics.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

int particle_number = 40000;

PostFX fx;
Particle mouse;
Particle[] others;
ParticleSystem physics;

PImage img, img2;
boolean USE_IMG = false;
boolean spiral=false;

float[] rand;



float[] m = new float[particle_number = 40000];
float[] x = new float[particle_number = 40000];
float[] y = new float[particle_number = 40000];
float[] vx = new float[particle_number = 40000];
float[] vy = new float[particle_number = 40000];



void setup() {
   
  size( 700, 700, P2D );
  //cursor( CROSS );
  background(0);

  rand = new float[5000];
  for (int i = 0; i < 5000; i++) {
    rand[i] = random(10)/10;
  }


  fx = new PostFX(this);  

  img = loadImage( "line.png" );
  img2 = loadImage( "line2.png" );
  imageMode( CORNER );

  physics = new ParticleSystem( 0, 0.1 );
  mouse = physics.makeParticle();
  mouse.makeFixed();

  others = new Particle[particle_number];

  for ( int i = 0; i < others.length; i++ ) {
    others[i] = physics.makeParticle( 1.0, random( 0, width ), random( 0, height ), 0 );
     m[i] = randomGaussian() * 16;
  }
}

boolean WHITE = true;
void draw() {
  fill(0);
  
  rect(0,0,width,height);
  surface.setTitle(str(frameRate));
  physics.tick();  
  //if (WHITE) {
  //  background( 14 );
  //} else {
  //  background( 140 );
  //}
  //pushStyle();
  //noStroke();
  //fill(0, 70);
  //popStyle();
  float w = 2;
  //if (WHITE) {
  //  stroke(255, 120);
  //} else {
  //  stroke(0, 120);
  //}

  if (spiral==false) {
    for ( int i = 0; i < others.length; i++ ) {
      pushMatrix();
      Particle p = others[i];

      //translate决定位置
      //translate(p.position().x()-w/2, p.position().y()-w/2);
      //rotate(rand[i % rand.length]);
      //println(i%rand.length);

      //translate(-w/2, -w/2);
      rotate(rand[i % rand.length]);
      
      //区分大小和颜色
      if (rand[i%rand.length]>0.118) {
        strokeWeight(1.0);

        stroke(145, 201, 248, 120);
      } else if (rand[i%rand.length]>0.113) {
        strokeWeight(3.9);
        stroke(254, 235, 199, 173);
      } else {
        strokeWeight(1.8);
        stroke(248, 225, 177, 144);
      }
      

  

      if (USE_IMG) { 
        if (WHITE) {

          tint( 255, 41 );
          image( img2, 0, 0);
        } else {

          tint( 12, 37 );
          image( img, 0, 0);
        }
      } else {
        point(p.position().x(), p.position().y());
      }
      if (p.position().x() > width || p.position().x() < 0) {
        p.position().setX(random(width));
      }
      if (p.position().y() > height || p.position().y() < 0) {
        p.position().setY(random(height));
      }
      popMatrix();
    }
    
  } else {

    for ( int i = 0; i < others.length; i++ ) {
      //rotate(rand[i % rand.length]);
      Particle p = others[i];
      x[i]= p.position().x();
      y[i]= p.position().y();
      float dx = mouseX - x[i];
      float dy = mouseY - y[i];
      float d = sqrt(dx*dx + dy*dy);
      if (d < 1) d = 1;
      float f = sin(d * 0.04) * m[i] / d;
      vx[i] = vx[i] * 0.5 + f * dx;
      vy[i] = vy[i] * 0.5 + f * dy;
      
       x[i] += vx[i];
      y[i] += vy[i];

      if (x[i] < 0) x[i] = width;
      else if (x[i] > width) x[i] = 0;

      if (y[i] < 0) y[i] = height;
      else if (y[i] > height) y[i] = 0;

      
      //println("change");
       p.position().setX(x[i]);
       p.position().setY(y[i]);
       
          if (rand[i%rand.length]>0.118) {
        strokeWeight(1.0);

        stroke(145, 201, 248, 120);
      } else if (rand[i%rand.length]>0.113) {
        strokeWeight(3.9);
        stroke(254, 235, 199, 173);
      } else {
        strokeWeight(1.8);
        stroke(248, 225, 177, 144);
      }
      
      
      point(x[i], y[i]);
      
    }
   
  }





  //fx.render() 
  //  .bloom(0.1, 13, 106) // damage visual of black particle
  //  .compose();
}

void spiral() {

  for (int i = 0; i < particle_number; i++) {
  }
}



void keyPressed() {
  if (keyCode == ' ') {
    WHITE = !WHITE;
  }

  if (keyCode == 'I') {
    USE_IMG = !USE_IMG;
  }

  if (keyCode == 'C') {

    spiral=!spiral;
  } 
  
}
void mouseMoved() {
}

void mousePressed() {
  //add Atrraction
  for ( int i = 0; i < others.length; i++ ) {
    physics.makeAttraction( mouse, others[i], -500, 0.15 );
  }
  mouse.position().set( mouseX, mouseY, 0 );
}

void mouseDragged() {
  mouse.position().set( mouseX, mouseY, 0 );
}

void mouseReleased() {
  for ( int i = 0; i < physics.numberOfAttractions(); i++ ) {
    Attraction t = physics.getAttraction(i);
    t.setStrength(-200);
  }

  for ( int i = 0; i < physics.numberOfAttractions(); i++ ) {
    physics.removeAttraction(i);
  }
}

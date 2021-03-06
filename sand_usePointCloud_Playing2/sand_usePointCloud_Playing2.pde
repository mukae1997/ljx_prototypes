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
boolean spiral=false, pspiral = false;
;

float[] rand;

float mousedcnter = 0;

PVector mse, pmse;

float[] m = new float[particle_number];
float[] x = new float[particle_number];
float[] y = new float[particle_number];
float[] vx = new float[particle_number];
float[] vy = new float[particle_number];

lifeStateTimer timer;

void setup() {

  size( 900, 700, P2D );
  
  //fullScreen(P2D);
  
  //cursor( CROSS );
  background(0);

  rand = new float[5000];
  for (int i = 0; i < 5000; i++) {
    rand[i] = random(10)/10;
  }

  timer = new lifeStateTimer(0.5);


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


  mse = new PVector(mouseX, mouseY);
  pmse = new PVector(pmouseX, pmouseY);
}

boolean WHITE = true;
void draw() {
  surface.setTitle(str(frameRate));


  pmse.set(mse.x, mse.y);
  mse.set(mouseX, mouseY);
  // debug
  //float t0 = frameCount * 0.14;
  //mse.set(width/2 + 250 * sin(t0), height/2 + 250 * cos(t0));
  
  
  pspiral = spiral;


  fill(0);
  noStroke();
  rect(0, 0, width, height);
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

  float moused = PVector.sub(mse, pmse).mag();
  mousedcnter += moused;
  mousedcnter *= 0.7;

  if (!triggerSpiral()) {
    if (canMakeAttraction()) {
      makeAttraction();
    }
    spiral = false;
  } else { 
    spiral = true;
  }

  timer.update();

  if (spiral==false) {

    for ( int i = 0; i < others.length; i++ ) {
      pushMatrix();
      Particle p = others[i];  


      //translate决定位置
      translate(p.position().x(), p.position().y());
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
        point(0, 0);
      }
      if (p.position().x() > width || p.position().x() < 0) {
        p.position().setX(random(width));
      }
      if (p.position().y() > height || p.position().y() < 0) {
        p.position().setY(random(height));
      }
      popMatrix();
    }
  } else 
  
  
  {



    if (moused > 25 && timer.isDead()) {
      timer.reset();
    }

    float t = frameCount * 0.011;
    
    float oscillAmp = moused * 0.012;
    float oscillBase = 0.05 * noise(t);
    
    
    for ( int i = 0; i < others.length; i++ ) {
      //rotate(rand[i % rand.length]);
      Particle p = others[i];
      x[i] = p.position().x();
      y[i] = p.position().y();
      float dx = mse.x - x[i];
      float dy = mse.y - y[i];
      float d = sqrt(dx*dx + dy*dy);
      
       d *= noise(d*0.005); // destroy circle
      
      if (d < 1) d = 1;
      float f = sin(d * (oscillBase + oscillAmp * sin(TWO_PI*timer.state)   )) * m[i] / d; 
      vx[i] = vx[i] * 0.5 + f * dx; // dx+, vx +
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


      point(p.position().x(), p.position().y());
      //point(x[i], y[i]);
    }
  }

  fx.render() 
    .bloom(0.1, 13, 106) // damage visual of black particle
    .compose();

  if (pspiral != spiral && spiral == true) {
    removeAttraction();
  } else if (canMakeAttraction()) { 
    makeAttraction();
  }


  // debug message

  printMousecnter();
}

void printMousecnter() {
  fill(255);
  String str = "MouseCnter : " + str(mousedcnter);
  text(str, 50, 50);
}
boolean canMakeAttraction() {
  int attractionTriggerBound = 6; // higher, harder
  return pspiral != spiral && spiral == false ||
    ( mousedcnter > attractionTriggerBound && !triggerSpiral() && frameCount % 22 == 0 );
}

void spiral() {

  for (int i = 0; i < particle_number; i++) {
  }
}



boolean triggerSpiral() {
  return mousedcnter > 21;
}

void makeAttraction() {
  //add Atrraction
  mouse.position().set( mse.x, mse.y, 0 );
  for ( int i = 0; i < others.length; i++ ) {
    if ( dist(mse.x, mse.y, others[i].position().x(), 
      others[i].position().y()) < 200)
      physics.makeAttraction( mouse, others[i], -500, 0.15 );
  }
}
void removeAttraction() {
  for ( int i = 0; i < physics.numberOfAttractions(); i++ ) {
    Attraction t = physics.getAttraction(i);
    t.setStrength(-200);
  }

  for ( int i = 0; i < physics.numberOfAttractions(); i++ ) {
    physics.removeAttraction(i);
  }
}

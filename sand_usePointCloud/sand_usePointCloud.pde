// 按空格切换配色
// 按 I 切换绘制 sprite/point

import traer.physics.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

int particle_number = 400;

PostFX fx;
Particle mouse;
Particle[] others;
ParticleSystem physics;

PImage img, img2;
boolean USE_IMG = false;

float[] rand;

void setup() {
  size( 1400, 700, P2D );
  //cursor( CROSS );

  rand = new float[5000];
  for (int i = 0; i < 5000; i++) {
    rand[i] = random(10)/10;
  }


  fx = new PostFX(this);  

  img = loadImage( "line.png" );
  img2 = loadImage( "fade2.png" );
  imageMode( CORNER );

  physics = new ParticleSystem( 0, 0.1 );
  mouse = physics.makeParticle();
  mouse.makeFixed();

  others = new Particle[particle_number];

  for ( int i = 0; i < others.length; i++ ) {
    others[i] = physics.makeParticle( 1.0, random( 0, width ), random( 0, height ), 0 );
  }
}

boolean WHITE = true;
void draw() {
  surface.setTitle(str(frameRate));
  physics.tick();  
  if (WHITE) {
    background( 22 );
  } else {
    background( 209 );
  }
  //pushStyle();
  //noStroke();
  //fill(0, 70);
  //popStyle();
  float w = 2;
  if (WHITE) {
    stroke(255, 120);
  } else {
    stroke(0, 120);
  }
  strokeWeight(1.0);
  for ( int i = 0; i < others.length; i++ ) {
    pushMatrix();
    Particle p = others[i];
    translate(p.position().x()-w/2, p.position().y()-w/2);
    rotate(rand[i % rand.length]);


    if (USE_IMG) { 
      if (WHITE) {

        tint( 255, 41 );
        image( img2, 0, 0);
      } else {

        tint( 12, 37 );
        image( img, 0, 0, 3, 55);
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


  //fx.render() 
  //  .bloom(0.1, 13, 106) // damage visual of black particle
  //  .compose();
}
void keyPressed() {
  if (keyCode == ' ') {
    WHITE = !WHITE;
  }

  if (keyCode == 'I') {
    USE_IMG = !USE_IMG;
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

// 按空格切换配色
// 按 I 切换绘制 sprite/point

import traer.physics.*;

Particle mouse;
Particle[] others;
ParticleSystem physics;

PImage img, img2;
boolean USE_IMG = false;
void setup() {
  size( 1000, 700 );
  //cursor( CROSS );

  img = loadImage( "fade.png" );
  img2 = loadImage( "fade2.png" );
  imageMode( CORNER );

  physics = new ParticleSystem( 0, 0.1 );
  mouse = physics.makeParticle();
  mouse.makeFixed();

  others = new Particle[20000];

  for ( int i = 0; i < others.length; i++ ) {
    others[i] = physics.makeParticle( 1.0, random( 0, width ), random( 0, height ), 0 );
  }
}

boolean WHITE = true;
void draw() {
  surface.setTitle(str(frameRate));
  physics.tick();  
  if (WHITE) {
    background( 0 );
  } else {
    background( 255 );
  }
  //pushStyle();
  //noStroke();
  //fill(0, 70);
  //popStyle();
  float w = 3;
  if (WHITE) {
    stroke(255, 120);
  } else {
    stroke(0, 120);
  }
  strokeWeight(1.0);
  for ( int i = 0; i < others.length; i++ ) {
    Particle p = others[i];
    if (USE_IMG) { 
      if (WHITE) {
        
  tint( 255, 32 );
        image( img2, p.position().x()-w/2, p.position().y()-w/2);
      } else {
        
  tint( 0, 32 );
        image( img, p.position().x()-w/2, p.position().y()-w/2);
      }
    } else {

      point(p.position().x(), p.position().y() );
    }
    if (p.position().x() > width || p.position().x() < 0) {
      p.position().setX(random(width));
    }
    if (p.position().y() > height || p.position().y() < 0) {
      p.position().setY(random(height));
    }
  }
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

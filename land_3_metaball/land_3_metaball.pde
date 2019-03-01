import traer.physics.*;

import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

PostFX fx;

ParticleSystem physics;
Particle[][] particles;
int jn = 40; // 横向绳子条数

float SPRING_STRENGTH = 0.01;
float SPRING_DAMPING = 0.1;
Particle[] mAtrs;
int m;


MetaballParticleSystem mbps;

PShader metaballShader;
float[] rand;
PVector[] rndvec;

void setup()
{
  size(900, 600, P3D);
  smooth();
  fill(0);

  rand = new float[5000]; 
  rndvec = new PVector[5000];
  for (int i = 0; i < 5000; i++) {
    rand[i] = random(5);
    rndvec[i] = PVector.random2D();
  }

  fx = new PostFX(this);  



  mbps = new MetaballParticleSystem(); 

  metaballShader = loadShader("metaballFrag.glsl", "metaballVert.glsl");



  physics = new ParticleSystem(0.0, 0.06); 

  float gridStepX = (float) ((width+200) / jn);
  float gridStepY = 15;


  m = floor((height) / gridStepY);
  particles = new Particle[m][jn];

  for (int i = 0; i < m; i++)
  {
    for (int j = 0; j < jn; j++)
    {
      particles[i][j] = physics.makeParticle(0.2, -50 + j * gridStepX 
        , i * gridStepY + 20, 0.0);
    }
  }
  println("particles number "+physics.numberOfParticles());
  println("attractions number "+physics.numberOfAttractions());

  for (int i = 0; i < m; i++)
  {

    for (int j = 1; j < jn; j++)
    {
      physics.makeSpring(particles[i][j-1], 
        particles[i][j], SPRING_STRENGTH, SPRING_DAMPING, gridStepX);

      particles[0][j].makeFixed();
    }
    //particles[i][jn - 1].makeFixed();
  }

  //particles[0][0].makeFixed();
  particles[0][jn - 1].makeFixed();



  float spring_looseness = 20; // bigger, looser

  //给每一个粒子的初始位置上加一个粒子，并且给出一个attract关系
  int currentParNumber = physics.numberOfParticles();
  for ( int i = 0; i < currentParNumber; ++i )
  {
    Particle p = physics.getParticle(i);
    //非attractor粒子
    if (!p.isFixed()) {
      Particle q = physics.makeParticle(); // fixed anchor
      q.position().set(p.position());

      q.makeFixed(); // used for resetting the curve to be straight line

      //physics.makeAttraction(q, p, 500, 5); // 并且给出一个attract关系
      physics.makeSpring(q, p, SPRING_STRENGTH, SPRING_DAMPING, 
        spring_looseness); // 并且给出一个attract关系
    }
  }
  println("particles number "+physics.numberOfParticles());
  println("attractions number "+physics.numberOfAttractions());





  float interactive_strength = -500;
  float interactive_minimumDistance = 1;
  mAtrs = new Particle[METABALL_NUM];// 活动粒子
  for (int i = 0; i<mAtrs.length; i++) {

    mAtrs[i] = physics.makeParticle();
    mAtrs[i].makeFixed();
  }
  println("particles number "+physics.numberOfParticles());
  println("attractions number "+physics.numberOfAttractions());

  for (int i = 0; i<mAtrs.length; i++) {
    //制造attractor和活动粒子之间关系
    for ( int j = 0; j < physics.numberOfParticles(); j++ )
    {
      Particle q = physics.getParticle( j );
      if ( mAtrs[i] != q && !q.isFixed())
        // 3rd parameter: sign -- attract or rebel
        // 4th: the less, the easier to be affected
        physics.makeAttraction( mAtrs[i], q, 
          interactive_strength, interactive_minimumDistance );
      //println("Make attraction");
    }
  }

  println("particles number "+physics.numberOfParticles());
  println("attractions number "+physics.numberOfAttractions());
  mbps.update();
}

void draw()
{

  surface.setTitle(str(frameRate));

  blendMode(ADD);
  physics.tick();
  Vector3D mse = new Vector3D(mouseX, mouseY, 0);

  for (int i = 0; i < mAtrs.length; i++) {
    MetaballParticle p = mbps.cles.get(i);
    if (!p.isDead()) {
      mAtrs[i].position().set(p.loc.x, p.loc.y, 0);
    }
  }
  //mAtrs[0].position().set(mouseX, mouseY, 0);
  //mAtrs[1].position().set(width/2, height/2, 0);


  //   movement for left-top corner
  //mse.subtract(particles[0][0].position()) ;
  //mse.multiplyBy(0.05); 
  //particles[0][0].velocity().add( mse);
  //if (mousePressed) { 
  //  particles[0][0].velocity().set(new Vector3D(10, -10, 0));
  //}


  noFill();

  background(21);
  stroke(244, 17);

  float t = frameCount * 0.074;
  for (int i = 0; i < m; i++)
  {
    pushMatrix();
    for (int k = 0; k < 3; k++) {
      translate(0, rand[i]*1.9);
      strokeWeight(0.5 + rand[i]*2.2);

      beginShape();
      curveVertex(particles[i][0].position().x(), 
        particles[i][0].position().y());
      for (int j = 0; j < jn; j++)
      {

        float px = particles[i][j].position().x(), 
          py = particles[i][j].position().y();

        py += 2.9 * noise(py*0.0055 + px, t);

        curveVertex(px, py);
      }
      curveVertex(particles[i][jn - 1].position().x(), 
        particles[i][jn - 1].position().y());
      endShape();
    }

    popMatrix();
  }

  // debug 
  pushStyle();
  strokeWeight(3.0);
  stroke(20);
  for (int i = 0; i < m; i++)
  {
    for (int j = 0; j < jn; j++)
    {
      //particles[i][j].position().setX(px); 
      //particles[i][j].position().setY(py);
    }
  }
  popStyle();

  fill(255, 80);
  mbps.update();
  mbps.render(this.g);



  fx.render() 
    .bloom(0.1, 13, 106) // damage visual of black particle
    .compose();
} 

import traer.physics.*;


ParticleSystem physics;
Particle[][] particles;
int jn = 30;

float SPRING_STRENGTH = 0.01;
float SPRING_DAMPING = 0.1;
Particle[] mAtrs;
int m;
void setup()
{
  size(1000, 780, P3D);
  smooth();
  fill(0);

  physics = new ParticleSystem(0.0, 0.06); 

  float gridStepX = (float) ((width+200) / jn);
  float gridStepY = 20;


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



  float interactive_strength = -4000;
  float interactive_minimumDistance = 5;
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
  mAtrs = new Particle[2];// 活动粒子
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
}

void draw()
{
  physics.tick();
  Vector3D mse = new Vector3D(mouseX, mouseY, 0);

  mAtrs[0].position().set(mouseX, mouseY, 0);
  mAtrs[1].position().set(width/2, height/2, 0);


  //   movement for left-top corner
  //mse.subtract(particles[0][0].position()) ;
  //mse.multiplyBy(0.05); 
  //particles[0][0].velocity().add( mse);
  //if (mousePressed) { 
  //  particles[0][0].velocity().set(new Vector3D(10, -10, 0));
  //}


  noFill();

  background(21);
  strokeWeight(3.1);
  stroke(244, 67);
  for (int i = 0; i < m; i++)
  {
    pushMatrix();
    for (int k = 0; k < 3; k++) {
      translate(0, 3);

      beginShape();
      curveVertex(particles[i][0].position().x(), particles[i][0].position().y());
      for (int j = 0; j < jn; j++)
      {
        curveVertex(particles[i][j].position().x(), particles[i][j].position().y());
      }
      curveVertex(particles[i][jn - 1].position().x(), particles[i][jn - 1].position().y());
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
      //point(particles[i][j].position().x(), particles[i][j].position().y());
    }
  }
  popStyle();
} 

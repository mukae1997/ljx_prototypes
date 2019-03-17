/*
按R去掉弹力
按A加上弹力（但是去掉一次以后复原不会和开始一样）
*/

import traer.physics.*;

import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

boolean isTriggerRemoveSpring = false;

PostFX fx;

ParticleSystem physics;
Particle[][] particles;
int jn = 40; // 横向绳子条数

Particle[] mAtrs;
int m;


MetaballParticleSystem mbps;

PShader metaballShader;
float[] rand;
PVector[] rndvec;


PVector mse = new PVector();
PVector pmse = new PVector();

rayParticleSystem raySys;

ArrayList<Particle> anchors = new ArrayList<Particle>(); // for make/remove springs 
ArrayList<Particle> movers = new ArrayList<Particle>(); // for make/remove springs
void setup()
{
  //size(900, 600, P3D);
  fullScreen(P3D);
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


  raySys = new rayParticleSystem(
    new PVector(0, 0, 0));

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
      anchors.add(q);
      //physics.makeAttraction(q, p, 500, 5); // 吸引式归位
      movers.add(p);
      // 让绳子归位
      //physics.makeSpring(q, p, SPRING_STRENGTH, SPRING_DAMPING, 
      //  spring_looseness); // 弹力式归位
    }
  }
  addAllSprings();

  println("particles number "+physics.numberOfParticles());
  println("attractions number "+physics.numberOfAttractions());
  println("spring number "+physics.numberOfSprings());





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
  
  noCursor();
}

void draw()
{
  /*  随机去除绳子节点和锚点之间的引力
   会使该节点无法归位, 散开
   */
  //randomlyRemoveSpring(); 
  
  

  surface.setTitle(str(frameRate));
  mse.set(mouseX, mouseY, 0);
  if (frameCount % 60 == 0) {
    pmse.set(mouseX, mouseY, 0);
  }

  blendMode(ADD);
  physics.tick();

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
      translate(0, rand[i]*1.9); // 控制重复画绳子的间隔
      strokeWeight(0.5 + rand[i]*2.2);// 控制重复画绳子的粗细

      beginShape();
      curveVertex(particles[i][0].position().x(), 
        particles[i][0].position().y());
      for (int j = 0; j < jn; j++)
      {

        float px = particles[i][j].position().x(), 
          py = particles[i][j].position().y();

        // 控制绳子上下波动的幅度和频率
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
  if (canAddWhirl(pmse, mse)) {
    /* 控制发射出来的粒子数量，第一个位置是诞生位置
     第二个是目标位置
     */
    raySys.emit(5, pmse, 
      mse);
    //println(raySys.raycles.size());
  }


  //for (rayParticle r : raySys.raycles) {
  //  r.setTarget(mse);  // todo : set emitter mechanism
  //}

  raySys.update();
  raySys.show();


  mbps.update();
  mbps.render(this.g);// must put last


  fx.render() 
    .bloom(0.1, 13, 106) // damage visual of black particle
    .compose();
    
    
  if (isTriggerRemoveSpring) {
    // 使得 removespring 最多生效一帧
    addAllSprings();
    isTriggerRemoveSpring = false;
  }
} 
boolean canAddWhirl(PVector p1, PVector p2) {
  // 判定应不应该添加漩涡粒子
  // 可以控制距离阈值和时间间隔
  if (PVector.dist(p1, p2) < 10 && frameCount % 1 == 0) return true;
  return false;
}
void keyReleased() {
  if (keyCode == 'R') {
    removeAllSprings();
  }
  if (keyCode == 'A') {
    addAllSprings();
  }
}

// 按空格切换配色
// 按 I 切换绘制 sprite/point
//加了轨迹效果 按C切换


import ddf.minim.*;
Minim minim;
AudioSample drop1,drop2,drop3,drop4;


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
boolean moverDEBUG = false;

float unknown_factor = 8;
float ratioForSave;

float[] rand;

float mousedcnter = 0;

PVector mse, pmse;

float[] m = new float[particle_number];
float[] x = new float[particle_number];
float[] y = new float[particle_number];
float[] vx = new float[particle_number];
float[] vy = new float[particle_number];

lifeStateTimer oscillTimer, expandTimer;
//MM mas;
void setup() {
 minim = new Minim(this);
  size( 900, 700, P2D );
  
  
   drop1 = minim.loadSample("drop1.mp3");
   drop2 = minim.loadSample("drop2.mp3");
   drop3 = minim.loadSample("drop3.mp3");
   drop4 = minim.loadSample("drop4.mp3");


  //fullScreen(P2D);

  //cursor( CROSS );
  noCursor();
  background(0);

  rand = new float[5000];
  for (int i = 0; i < 5000; i++) {
    rand[i] = random(10)/10;
  }

  oscillTimer = new lifeStateTimer(0.5);
  expandTimer = new lifeStateTimer(1.5);


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

  //mas = new MM(new PVector(width/2, height/2), 5);
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

  oscillTimer.update();
  expandTimer.update();

  float moused = PVector.sub(mse, pmse).mag();
  mousedcnter += moused;
  mousedcnter *= 0.7;

  if (!triggerSpiral() && false) {
    if (canMakeAttraction()) {
      makeAttraction();
    }
    spiral = false;
  } else { 
    spiral = true;
  }
  //mas.steerTo(mse, 4);
  //mas.update();
  //if (moverDEBUG) {
  //  mas.show();
  //}
  //if (canMakeAttraction()) {
  //  makeAttraction();
  //}
  //if (spiral==false) {

  //  for ( int i = 0; i < others.length; i++ ) {
  //    pushMatrix();
  //    Particle p = others[i];  


  //    //translate决定位置
  //    translate(p.position().x(), p.position().y());
  //    //rotate(rand[i % rand.length]);
  //    //println(i%rand.length);

  //    //translate(-w/2, -w/2);
  //    rotate(rand[i % rand.length]);

  //    //区分大小和颜色
  //    if (rand[i%rand.length]>0.118) {
  //      strokeWeight(1.0);

  //      stroke(145, 201, 248, 120);
  //    } else if (rand[i%rand.length]>0.113) {
  //      strokeWeight(3.9);
  //      stroke(254, 235, 199, 173);
  //    } else {
  //      strokeWeight(1.8);
  //      stroke(248, 225, 177, 144);
  //    }




  //    if (USE_IMG) { 
  //      if (WHITE) {

  //        tint( 255, 41 );
  //        image( img2, 0, 0);
  //      } else {

  //        tint( 12, 37 );
  //        image( img, 0, 0);
  //      }
  //    } else {
  //      point(0, 0);
  //    }
  //    if (p.position().x() > width || p.position().x() < 0) {
  //      p.position().setX(random(width));
  //    }
  //    if (p.position().y() > height || p.position().y() < 0) {
  //      p.position().setY(random(height));
  //    }
  //    popMatrix();
  //  }
  //} else 


  {

    /*
按鼠标的时候会重启oscillTimer，
     它用于实现一个点击鼠标时产生一个
     震荡波（？）效果
     */

    if (moused > 25 && oscillTimer.isDead()) {
      oscillTimer.reset();
    }

    float t = frameCount * 0.011;

    // 这两个是震荡波的参数，控制最小幅度、震荡幅度
    float oscillAmp = moused * 0.019;
    float oscillBase = 0.04 + 0.15 *(1-expandTimer.state);

    for ( int i = 0; i < others.length; i++ ) {
      //rotate(rand[i % rand.length]);
      Particle p = others[i];
      x[i] = p.position().x();
      y[i] = p.position().y();
      float dx = mse.x - x[i];
      float dy = mse.y - y[i];
      float d = sqrt(dx*dx + dy*dy);

      float at = getTwistValue(x[i], y[i]);

      if (at < 0) at+=TWO_PI;
      //at = pow(at, 2);
      
      
      // twistRatio表示2种计算结果的混合比例
      // twistRatio=0时就是原来的环形轨迹
      // twistRatio = 1时完全是柏林噪声向量场
       //d *= noise(d*0.005);
     
     float twistRatio = map(sin(millis()*0.001),-1,1,0,1);
     ratioForSave=twistRatio;
     
     twistRatio=ratioForSave;
     //float twistRatio=0.2;
      
      d = lerp(d, d*at, twistRatio); 

      float dfac = 0.22; // 我没看出来现在的算法下这个有什么用
      if (d < 1) d = 1;
      
      float f = sin(dfac * d * (oscillBase + oscillAmp * sin(TWO_PI*oscillTimer.state)   )) * m[i];
      f /= (d*1.0);
      vx[i] = vx[i] * 0.5 + f * dx ; // dx+, vx +
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
    .bloom(0.2, 18, 106) // damage visual of black particle
    .compose();

  //if (pspiral != spiral && spiral == true) {
  //  removeAttraction();
  //} else if (canMakeAttraction()) { 
  //  makeAttraction();
  //}


  // debug message

  printMousecnter();
}

float getTwistValue(float x, float y) {
  //PVector cen = getCen(frameCount * 0.01 * 0.05);
  //int n = mas.sms.size();
  //float avg = 0;
  //float mind = 10000, minat = 1;
  //for (int i = 0; i < n; i++ ) {
  //  SM s = mas.sms.get(i);
  //  float d = dist(s.pos.x, s.pos.y, x, y);
  //  float at = atan2(y - s.pos.y, x - s.pos.x);
  //  avg += d*0.01 * at;
  //  if (mind > d) {
  //    minat = at;
  //    mind = d;
  //  }
  //} 
  //avg /= n;
  //if (minat < 0) minat += TWO_PI;
  // 调整线间距,数值越大（噪声变化频率越高）间距越小
  // 分 x y 方向调整
  float yfreq_factor = 0.0140;
  float xfreq_factor = 0.0060;
   // 我也忘了有什么用
  //return noise(y*yfreq_factor, x*xfreq_factor) * TWO_PI * unknown_factor;
  
  //下面两条是圆形轨迹效果 都挺好看的！
  
  return unknown_factor* 1.0*map(noise(millis()*0.0004),0,1,1,1.2);
  //return unknown_factor* 1.0*map(noise(y*yfreq_factor),0,1,1,1.2);
  //该值能不能按粒子数与音波高低一一对应？按照最高点
  //return 0.8;
  //return noise(millis()*0.001) * unknown_factor;
  //return atan2(abs(y-cen.x), abs(x-cen.y));
}


PVector getCen(float t) {
  return new PVector(width/2 + 250*sin(t), 
    height/2 + 250*sin(t));
}
void printMousecnter() {
  fill(255);
  String str = "MouseCnter : " + str(mousedcnter);
  text(str, 50, 50);
  String ratio= "twistRatio:"+str(ratioForSave);
  text(ratio,50,80);
}
boolean canMakeAttraction() {
  int attractionTriggerBound = 1; 
  return pspiral != spiral && spiral == false ||
    ( mousedcnter < attractionTriggerBound && !triggerSpiral() && frameCount % 22 == 0 );
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

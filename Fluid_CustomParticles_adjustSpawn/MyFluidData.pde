


// array is allocated automatically
float[] data_vel;
float vscale = 30;

int EMITTER_NUMBER = 15;

// control spawn

ArrayList<PVector> originalPoses = new ArrayList<PVector>();
ArrayList<PVector> poses = new ArrayList<PVector>();

ArrayList<PVector> vels = new ArrayList<PVector>();
void initMyFluidDataControl() {


  // ----------- my modify ----------

  // customize emitters

  // todo : switch to random poses

  float border = 200;

  float t = frameCount * 0.05; 

  if (!false) { 
    poses.add(new PVector(border, border));
    poses.add(new PVector(width - border, border));
    poses.add(new PVector(border, height - border));
    poses.add(new PVector(width - border, height - border));


    poses.add(new PVector(width/2, border));
    poses.add(new PVector(width/2, height - border));
    poses.add(new PVector(border, height/2));
    poses.add(new PVector(width - border, height/2));


    poses.add(new PVector(width/2 - 200, height/2));
    poses.add(new PVector(width/2 + 200, height/2));


    vels.add(new PVector(cos(t), -sin(t)).mult(vscale));
    vels.add(new PVector(-cos(t), -sin(t)).mult(vscale));
    vels.add(new PVector(cos(t), -sin(t)).mult(vscale));
    vels.add(new PVector(-cos(t), -sin(t)).mult(vscale));


    vels.add(new PVector(0, -1).mult(vscale));
    vels.add(new PVector(0, -1).mult(vscale));
    vels.add(new PVector(1, 0).mult(vscale));
    vels.add(new PVector(-1, 0).mult(vscale));


    vels.add(new PVector(-1, -1).mult(vscale));
    vels.add(new PVector(1, -1).mult(vscale));
  }

  for (int i = 0; i < EMITTER_NUMBER; i++) {
    poses.add(new PVector(random(border, width-border), random(border, height-border)));
    //vels.add(PVector.random2D().mult(vscale));
  }

  for (int i = 0; i < poses.size(); i++) {
    originalPoses.add(poses.get(i).copy());
  }
}

private class MyFluidData implements DwFluid2D.FluidData {

  // update() is called during the fluid-simulation update step.
  @Override
    public void update(DwFluid2D fluid) {

    float px, py, vx, vy, radius, temperature;

    radius = 100;
    //vscale = 30;
    px     = width/2;
    py     = 50;
    vx     = 1 * +vscale;
    vy     = 1 *  vscale;
    radius = 40;
    temperature = 1f;
    int DISTANCE_BOUND = 180;
    PVector mousePos = new PVector(mouseX, mouseY);

    float t = frameCount * 0.05; 

    for (int i = 0; i < poses.size(); i++) {
      PVector p = poses.get(i); 
      PVector diff = PVector.sub(p, mousePos);
      if (true||OutOfScreen(p)) {
        p.add(PVector.sub(originalPoses.get(i), p).mult(0.01));
      }

      if (diff.mag() < DISTANCE_BOUND) {
        p.add(diff.mult(0.3));
      }

      float local_px = p.x, local_py = p.y;
      //PVector v = vels.get(i).copy();
      PVector v = new PVector(2*(noise(t, i)-0.5), 2*(noise(10*i, t)-0.5)).mult(vscale);


      //v.x += 10*vscale*sin(frameCount*0.05+i);
      //v.y +=  vscale*cos(frameCount*0.05+i);

      fluid.addVelocity(local_px, local_py, radius, v.x, v.y);
      fluid.addDensity(local_px, local_py, radius, 0.2f, 0.3f, 0.5f, 1.0f);
      fluid.addTemperature(local_px, local_py, radius, temperature);

      particles.spawn(fluid, local_px, local_py, radius, 100); // default spawn
    }


    // ----------- my modify ----------

    boolean mouse_input = !cp5.isMouseOver() && mousePressed;

    // add impulse: density + velocity, particles
    if (mouse_input && mouseButton == LEFT && false) {
      radius = 15;
      vscale = 15;
      px     = mouseX;
      py     = height-mouseY;
      vx     = (mouseX - pmouseX) * +vscale;
      vy     = (mouseY - pmouseY) * -vscale;
      fluid.addDensity (px, py, radius, 0.25f, 0.0f, 0.1f, 1.0f);
      fluid.addVelocity(px, py, radius, vx, vy);
      particles.spawn(fluid, px, py, radius*2, 300);
    }

    // add impulse: density + temperature, particles
    if (mouse_input && mouseButton == CENTER) {
      radius = 15;
      vscale = 15;
      px     = mouseX;
      py     = height-mouseY;
      temperature = 2f;
      fluid.addDensity(px, py, radius, 0.25f, 0.0f, 0.1f, 1.0f);
      fluid.addTemperature(px, py, radius, temperature);
      particles.spawn(fluid, px, py, radius, 100);
    }

    // particles
    if (mouse_input && mouseButton == RIGHT) {
      px     = mouseX;
      py     = height - 1 - mouseY; // invert
      radius = 50;
      particles.spawn(fluid, px, py, radius, 300);
    }
  }
}

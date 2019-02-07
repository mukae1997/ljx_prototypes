


// array is allocated automatically
float[] data_vel;
float vscale = 30;

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

    // ----------- my modify ----------

    // customize emitters

    ArrayList<PVector> poses = new ArrayList<PVector>();
    float border = 200;
    if (false) {
      poses.add(new PVector(width/3 + border * cos(frameCount * 0.05), 
        height/2 +  border * sin(frameCount * 0.05)));

      poses.add(new PVector(width*0.6 + border * cos(frameCount * 0.05 + 5), 
        height/2 +   1 * sin(frameCount * 0.05 + 5)));
      poses.add(new PVector(width*0.6 + border * cos(frameCount * 0.05 + 15), 
        height/2 +   1 * sin(frameCount * 0.05 + 5)));
      poses.add(new PVector(width*0.6 + border * cos(frameCount * 0.05 + 25), 
        height/2 +   1 * sin(frameCount * 0.05 + 5)));
    }
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
    }

    ArrayList<PVector> vels = new ArrayList<PVector>();
    if (false) {
      vels.add(PVector.random2D().mult(vscale));
      vels.add(PVector.random2D().mult(vscale));
      vels.add(PVector.random2D().mult(vscale));
      vels.add(PVector.random2D().mult(vscale));
    }
    float t = frameCount * 0.05;
    if (!false) {
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

    for (int i = 0; i < poses.size(); i++) {
      PVector p = poses.get(i); 
      float local_px = p.x, local_py = p.y;
      PVector v = vels.get(i).copy();
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

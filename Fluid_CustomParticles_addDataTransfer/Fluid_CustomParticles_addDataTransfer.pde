/**
 * 
 * PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
 * 
 * A Processing/Java library for high performance GPU-Computing (GLSL).
 * MIT License: https://opensource.org/licenses/MIT
 * 
 */


import java.util.ArrayList;
import java.util.Iterator;

import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;

import controlP5.Accordion;
import controlP5.ControlP5;
import controlP5.Group;
import controlP5.RadioButton;
import controlP5.Toggle;
import processing.core.*;
import processing.opengl.PGraphics2D;
import processing.opengl.PJOGL;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;

// Fluid_CustomParticles show how to setup a completely customized particle
// system that is interacting with the fluid simulation.
// The particle data (positions) is stored in an OpenGL texture (GL_RGBA32F) 
// and gets updated each frame using GLSL shaders.
// No Data transfer (application <-> device), is required.
//
//
// controls:
//
// LMB: add Particles + Velocity
// MMB: add Particles
// RMB: add Particles




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

// -------------------------------------
// -------------------------------------
// ------------- my modify -------------

MetaBallTest mb;
Particle3DSystem ps;

boolean USE_METABALLS = !true;

CVImage img;

ArrayList<MatOfPoint> contours = new ArrayList<MatOfPoint>();

float beyondScreenBorder = 80;
// ------------- my modify -------------
// -------------------------------------
// -------------------------------------
int viewport_w = 1280;
int viewport_h = 720;
int viewport_x = 230;
int viewport_y = 0;

int gui_w = 200;
int gui_x = 20;
int gui_y = 20;

int fluidgrid_scale = 3;

DwFluid2D fluid;

// render targets
PGraphics2D pg_fluid;
//texture-buffer, for adding obstacles
PGraphics2D pg_obstacles;

PGraphics2D pg_metaball;

// custom particle system
MyParticleSystem particles;

// some state variables for the GUI/display
int     BACKGROUND_COLOR           = 0;
boolean UPDATE_FLUID               = true;
boolean DISPLAY_FLUID_TEXTURES     = true;
boolean DISPLAY_FLUID_VECTORS      = false;
int     DISPLAY_fluid_texture_mode = 0;
boolean DISPLAY_PARTICLES          = true;

boolean showObstacles = !true;


public void settings() {
  size(viewport_w, viewport_h, P2D);
  smooth(4);
  PJOGL.profile = 3;


  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
}

DwPixelFlow context; 

public void setup() {
  ps = new Particle3DSystem(0, new PVector(0, 0, 0));
  mb = new MetaBallTest(this);

  img = new CVImage(viewport_w, viewport_h);


  surface.setLocation(viewport_x, viewport_y);

  // main library context
  context = new DwPixelFlow(this);
  context.print();
  context.printGL();

  // fluid simulation
  fluid = new DwFluid2D(context, viewport_w, viewport_h, fluidgrid_scale);

  // set some simulation parameters
  fluid.param.dissipation_density     = 0.999f;
  fluid.param.dissipation_velocity    = 0.99f;
  fluid.param.dissipation_temperature = 0.80f;
  fluid.param.vorticity               = 0.10f;

  // ------------- my modify -------------
  //fluid.param.num_jacobi_projection = 67;
  fluid.param.timestep = 0.48;
  // ------------- my modify -------------


  // interface for adding data to the fluid simulation
  MyFluidData cb_fluid_data = new MyFluidData();
  fluid.addCallback_FluiData(cb_fluid_data);

  // pgraphics for fluid
  pg_fluid = (PGraphics2D) createGraphics(viewport_w, viewport_h, P2D);
  pg_fluid.smooth(4);
  pg_fluid.beginDraw();
  pg_fluid.background(BACKGROUND_COLOR);
  pg_fluid.endDraw();

  pg_metaball =  (PGraphics2D) createGraphics(viewport_w, viewport_h, P2D);

  // pgraphics for obstacles
  pg_obstacles = (PGraphics2D) createGraphics(viewport_w, viewport_h, P2D);
  pg_obstacles.smooth(4);
  pg_obstacles.beginDraw();
  pg_obstacles.clear();
  float radius;
  radius = 200;
  pg_obstacles.stroke(64);
  pg_obstacles.strokeWeight(10);
  pg_obstacles.noFill();
  pg_obstacles.rect(1*width/2f, 1*height/4f, radius, radius, 20);
  // border-obstacle
  pg_obstacles.strokeWeight(20);
  pg_obstacles.stroke(64);
  pg_obstacles.noFill();
  pg_obstacles.rect(0, 0, pg_obstacles.width, pg_obstacles.height);
  pg_obstacles.endDraw();

  fluid.addObstacles(pg_obstacles);

  // custom particle object
  particles = new MyParticleSystem(context, 1000 * 1000);

  createGUI();

  background(0);
  frameRate(60);
}




DwGLTexture tex_vel_small;

public void draw() { 



  // update simulation
  if (UPDATE_FLUID) {
    if (USE_METABALLS) {
      pg_metaball.beginDraw();
      pg_metaball.clear();
      pg_metaball.background(0);

      float radius;
      radius = 200; 

      //pg_obstacles.stroke(64);
      //pg_obstacles.strokeWeight(10);
      //pg_obstacles.noFill();
      //pg_obstacles.rect(1*width/2f, 1*height/4f, radius, radius, 20);
      pg_metaball.stroke(255);
      drawMetaBalls(pg_metaball); 
      pg_metaball.endDraw();
    } else {

      ps.update();
      if (frameCount % 60 == 0) 
        println(ps.cles.size());

      if (mousePressed && frameCount % 1 == 0) {
        PVector p = new PVector(mouseX, mouseY, 0);
        p.add(PVector.random2D().mult(20));
        ps.addParticles(2, p);
      }
    }

    img.copyTo( pg_metaball.get() ); // for opencv use

    // rendering obstacles

    pg_obstacles.beginDraw(); 
    pg_obstacles.clear();
    if (USE_METABALLS) {
      if (frameCount % 1 == 0) { // reduce update by CV
        Mat hierarchy = new Mat();
        Imgproc.findContours(img.getGrey(), contours, hierarchy, 
          Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_SIMPLE);
        // Imgproc.RETR_EXTERNAL
        // Imgproc.RETR_FLOODFILL
      }
      pg_obstacles.stroke(64);
      pg_obstacles.strokeWeight(10);
      //pg_obstacles.noFill();

      drawPolygons(contours, pg_obstacles);
    } else {

      ps.show(pg_obstacles);
    }
    //pg_obstacles.stroke(64);
    //pg_obstacles.strokeWeight(10);
    //pg_obstacles.noFill();
    //pg_obstacles.rect(mouseX, mouseY, 100, 100);

    // border-obstacle

    pg_obstacles.strokeWeight(20);
    pg_obstacles.stroke(64);
    pg_obstacles.noFill();
    pg_obstacles.rect(0 - beyondScreenBorder, 0 - beyondScreenBorder, 
      pg_obstacles.width + beyondScreenBorder, pg_obstacles.height + beyondScreenBorder);
    pg_obstacles.endDraw();


    fluid.addObstacles(pg_obstacles);
    fluid.update();
    particles.update(fluid);

    ////////////////////////////////////////////////
    // data transfer(some problem; not well adapted)

    int grid_points = 20;

    if (tex_vel_small == null) {
      tex_vel_small = fluid.tex_velocity.src.createEmtpyCopy();
      tex_vel_small.resize(context, grid_points, grid_points);
    }

    DwFilter.get(context).copy.apply(fluid.tex_velocity.src, tex_vel_small);

    // transfer velocity frame
    context.begin();
    data_vel = tex_vel_small.getFloatTextureData(data_vel);
    context.end();


    // draw velocity vectors
    float vel_mult = 2;
    float grid_space = fluid.fluid_w / (float)(grid_points + 1);

    beginShape(LINES);
    strokeWeight(1);
    stroke(255);
    for (int gy = 0; gy < grid_points; gy++) {
      for (int gx = 0; gx < grid_points; gx++) {

        float gx_pos1 = grid_space + gx * grid_space;
        float gy_pos1 = grid_space + gy * grid_space;

        int gid_fluid = (grid_points - 1 - gy) * tex_vel_small.w + gx; // inverted y-coord

        float vel_x = data_vel[gid_fluid * 2 + 0];
        float vel_y = data_vel[gid_fluid * 2 + 1];

        float gx_pos2 = gx_pos1 + vel_x * vel_mult;
        float gy_pos2 = gy_pos1 - vel_y * vel_mult; // inverted y-velocity

        vertex(gx_pos1, gy_pos1);
        vertex(gx_pos2, gy_pos2);
      }
    }
    endShape();
  }

  // clear render target
  pg_fluid.beginDraw();
  pg_fluid.background(BACKGROUND_COLOR);
  pg_fluid.endDraw();


  // render fluid stuff
  if (DISPLAY_FLUID_TEXTURES) {
    // render: density (0), temperature (1), pressure (2), velocity (3)
    fluid.renderFluidTextures(pg_fluid, DISPLAY_fluid_texture_mode);
  }

  if (DISPLAY_FLUID_VECTORS) {
    // render: velocity vector field
    fluid.renderFluidVectors(pg_fluid, 10);
  }

  if ( DISPLAY_PARTICLES) {
    // render: particles; 0 ... points, 1 ...sprite texture, 2 ... dynamic points
    particles.render(pg_fluid, BACKGROUND_COLOR);
  }


  // display
  image(pg_fluid, 0, 0);
  if (showObstacles) {
    image(pg_obstacles, 0, 0);
  }
  if (USE_METABALLS) {
    //mb.show();
    fill(0, 180);
    drawPolygons(contours, (PGraphics2D)this.g);
  } else {
    pushStyle();
    noStroke();

    fill(BACKGROUND_COLOR, 180);

    ps.show();
    popStyle();
  }
  //image(pg_metaball, 0, 0);


  // display number of particles as text
  String txt_num_particles = String.format("Particles  %,d", 
    particles.ALIVE_PARTICLES);
  fill(0, 0, 0, 220);
  noStroke();
  rect(10, height-10, 160, -30);
  fill(255, 128, 0);
  text(txt_num_particles, 20, height-20);

  // info
  String txt_fps = String.format(getClass().getName()+ "   [size %d/%d]   [frame %d]   [fps %6.2f]", fluid.fluid_w, fluid.fluid_h, fluid.simulation_step, frameRate);
  surface.setTitle(txt_fps);
}



public void fluid_resizeUp() {
  fluid.resize(width, height, fluidgrid_scale = max(1, --fluidgrid_scale));
}
public void fluid_resizeDown() {
  fluid.resize(width, height, ++fluidgrid_scale);
}
public void fluid_reset() {
  fluid.reset();
}
public void fluid_togglePause() {
  UPDATE_FLUID = !UPDATE_FLUID;
}
public void fluid_displayMode(int val) {
  DISPLAY_fluid_texture_mode = val;
  DISPLAY_FLUID_TEXTURES = DISPLAY_fluid_texture_mode != -1;
}
public void fluid_displayVelocityVectors(int val) {
  DISPLAY_FLUID_VECTORS = val != -1;
}

public void fluid_displayParticles(int val) {
  DISPLAY_PARTICLES = val != -1;
}

public void keyReleased() {
  if (key == 'p') fluid_togglePause(); // pause / unpause simulation
  if (key == '+') fluid_resizeUp();    // increase fluid-grid resolution
  if (key == '-') fluid_resizeDown();  // decrease fluid-grid resolution
  if (key == 'r') fluid_reset();       // restart simulation

  if (key == '1') DISPLAY_fluid_texture_mode = 0; // density
  if (key == '2') DISPLAY_fluid_texture_mode = 1; // temperature
  if (key == '3') DISPLAY_fluid_texture_mode = 2; // pressure
  if (key == '4') DISPLAY_fluid_texture_mode = 3; // velocity

  if (key == 'q') DISPLAY_FLUID_TEXTURES = !DISPLAY_FLUID_TEXTURES;
  if (key == ' ') showObstacles = !showObstacles;
  if (key == 'w') DISPLAY_FLUID_VECTORS  = !DISPLAY_FLUID_VECTORS;
  if (key == 's') {

    mb.particles.add(new MetaballParticle(mouseX, mouseY));
  }

  if (key == 'M') {
    USE_METABALLS = !USE_METABALLS;
  }
}



ControlP5 cp5;

public void createGUI() {
  cp5 = new ControlP5(this);

  int sx, sy, px, py, oy;

  sx = 100; 
  sy = 14; 
  oy = (int)(sy*1.5f);


  ////////////////////////////////////////////////////////////////////////////
  // GUI - FLUID
  ////////////////////////////////////////////////////////////////////////////
  Group group_fluid = cp5.addGroup("fluid");
  {
    group_fluid.setHeight(20).setSize(gui_w, 300)
      .setBackgroundColor(color(16, 180)).setColorBackground(color(16, 180));
    group_fluid.getCaptionLabel().align(CENTER, CENTER);

    px = 10; 
    py = 15;

    cp5.addButton("reset").setGroup(group_fluid).plugTo(this, "fluid_reset"     ).setSize(80, 18).setPosition(px, py);
    cp5.addButton("+"    ).setGroup(group_fluid).plugTo(this, "fluid_resizeUp"  ).setSize(39, 18).setPosition(px+=82, py);
    cp5.addButton("-"    ).setGroup(group_fluid).plugTo(this, "fluid_resizeDown").setSize(39, 18).setPosition(px+=41, py);

    px = 10;

    cp5.addSlider("velocity").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
      .setRange(0, 1).setValue(fluid.param.dissipation_velocity).plugTo(fluid.param, "dissipation_velocity");

    cp5.addSlider("density").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 1).setValue(fluid.param.dissipation_density).plugTo(fluid.param, "dissipation_density");

    cp5.addSlider("temperature").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 1).setValue(fluid.param.dissipation_temperature).plugTo(fluid.param, "dissipation_temperature");

    cp5.addSlider("vorticity").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 1).setValue(fluid.param.vorticity).plugTo(fluid.param, "vorticity");

    cp5.addSlider("iterations").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 80).setValue(fluid.param.num_jacobi_projection).plugTo(fluid.param, "num_jacobi_projection");

    cp5.addSlider("timestep").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 1).setValue(fluid.param.timestep).plugTo(fluid.param, "timestep");

    cp5.addSlider("gridscale").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 50).setValue(fluid.param.gridscale).plugTo(fluid.param, "gridscale");

    RadioButton rb_setFluid_DisplayMode = cp5.addRadio("fluid_displayMode").setGroup(group_fluid).setSize(80, 18).setPosition(px, py+=(int)(oy*1.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(2)
      .addItem("Density", 0)
      .addItem("Temperature", 1)
      .addItem("Pressure", 2)
      .addItem("Velocity", 3)
      .activate(DISPLAY_fluid_texture_mode);
    for (Toggle toggle : rb_setFluid_DisplayMode.getItems()) toggle.getCaptionLabel().alignX(CENTER);

    cp5.addRadio("fluid_displayVelocityVectors").setGroup(group_fluid).setSize(18, 18).setPosition(px, py+=(int)(oy*2.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
      .addItem("Velocity Vectors", 0)
      .activate(DISPLAY_FLUID_VECTORS ? 0 : 2);
  }


  ////////////////////////////////////////////////////////////////////////////
  // GUI - DISPLAY
  ////////////////////////////////////////////////////////////////////////////
  Group group_display = cp5.addGroup("display");
  {
    group_display.setHeight(20).setSize(gui_w, 50)
      .setBackgroundColor(color(16, 180)).setColorBackground(color(16, 180));
    group_display.getCaptionLabel().align(CENTER, CENTER);

    px = 10; 
    py = 15;

    cp5.addSlider("BACKGROUND").setGroup(group_display).setSize(sx, sy).setPosition(px, py)
      .setRange(0, 255).setValue(BACKGROUND_COLOR).plugTo(this, "BACKGROUND_COLOR");

    cp5.addRadio("fluid_displayParticles").setGroup(group_display).setSize(18, 18).setPosition(px, py+=(int)(oy*1.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
      .addItem("display particles", 0)
      .activate(DISPLAY_PARTICLES ? 0 : 2);
  }


  ////////////////////////////////////////////////////////////////////////////
  // GUI - CUSTOM
  ////////////////////////////////////////////////////////////////////////////
  Group group_custom = cp5.addGroup("custom");
  {
    group_custom.setHeight(20).setSize(gui_w, 50)
      .setBackgroundColor(color(16, 180)).setColorBackground(color(16, 180));
    group_custom.getCaptionLabel().align(CENTER, CENTER);

    px = 10; 
    py = 15;

    cp5.addSlider("point_size").setGroup(group_custom).setSize(sx, sy).setPosition(px, py)
      .setRange(0, 20).setValue(particles.point_size).plugTo(particles, "point_size");


    cp5.addSlider("OBSTACLE_CIRCLE_SIZE").setGroup(group_custom).setSize(sx, sy).setPosition(px, py += oy)
      .setRange(5, 500).setValue( ps.BASE_R ).plugTo(ps, "BASE_R");


    cp5.addSlider("beyondScreenBorder").setGroup(group_custom).setSize(sx, sy).setPosition(px, py += oy)
      .setRange(-300, 300).setValue( beyondScreenBorder );


    cp5.addSlider("vscale").setGroup(group_custom).setSize(sx, sy).setPosition(px, py += oy)
      .setRange(1, 50).setValue( vscale );


    //cp5.addSlider("PARTICLE_COL_H").setGroup(group_custom).setSize(sx, sy).setPosition(px, py += oy)
    //  .setRange(0,1).setValue( particles.particle_color_h ).plugTo(ps, "particle_color_h");


    //cp5.addSlider("PARTICLE_COL_S").setGroup(group_custom).setSize(sx, sy).setPosition(px, py += oy)
    //  .setRange(0,1).setValue( particles.particle_color_s ).plugTo(ps, "particle_color_s");


    //cp5.addSlider("PARTICLE_COL_B").setGroup(group_custom).setSize(sx, sy).setPosition(px, py += oy)
    //  .setRange(0,1).setValue( particles.particle_color_b ).plugTo(ps, "particle_color_b");
  }

  ////////////////////////////////////////////////////////////////////////////
  // GUI - ACCORDION
  ////////////////////////////////////////////////////////////////////////////
  cp5.addAccordion("acc").setPosition(gui_x, gui_y).setWidth(gui_w).setSize(gui_w, height)
    .setCollapseMode(Accordion.MULTI)
    .addItem(group_fluid)
    .addItem(group_display)
    .addItem(group_custom)
    .open(4);
}

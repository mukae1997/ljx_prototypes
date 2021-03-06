/**
 * 
 * PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
 * 
 * A Processing/Java library for high performance GPU-Computing (GLSL).
 * MIT License: https://opensource.org/licenses/MIT
 * 
 */


import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLTexture;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;

import processing.core.*;
import processing.opengl.PGraphics2D;


  // Basic example for texture data transfer

  DwPixelFlow context;
  
  // fluid simulation
  DwFluid2D fluid;
  
  // render targets
  PGraphics2D pg_fluid;
  
  public void settings() {
    size(600, 600, P2D);
  }
  
    int fluid_gridscale = 3;
  public void setup() {
       
    // library context
    context = new DwPixelFlow(this);
    context.print();
    context.printGL();
    System.out.println("Example: "+this.getClass().getSimpleName());
    
    // fluid simulation
    fluid = new DwFluid2D(context, width, height, fluid_gridscale);
    
    // some fluid parameters
    fluid.param.dissipation_velocity = 0.90f;
    fluid.param.dissipation_density  = 0.99f;

    // adding data to the fluid simulation
    fluid.addCallback_FluiData(new  DwFluid2D.FluidData(){
      public void update(DwFluid2D fluid) {
        if(mousePressed){
          float px     = mouseX;
          float py     = height-mouseY;
          float vx     = (mouseX - pmouseX) * +15;
          float vy     = (mouseY - pmouseY) * -15;
          fluid.addVelocity(px, py, 14, vx, vy);
          fluid.addDensity (px, py, 20, 0.0f, 0.4f, 1.0f, 1.0f);
          fluid.addDensity (px, py,  8, 1.0f, 1.0f, 1.0f, 1.0f);
        }
        
        float px     = fluid.fluid_w/2;
        float py     = 0;
        fluid.addDensity (px, py, 50, 1.0f, 0.4f, 0.0f, 1.0f);
        fluid.addDensity (px, py, 40, 1.0f, 1.0f, 1.0f, 1.0f);
        fluid.addTemperature(px, py, 50, 2);
      }
    });
   
    // render-target
    pg_fluid = (PGraphics2D) createGraphics(width, height, P2D);
    pg_fluid.smooth(8);
    
    frameRate(60);
  }
  
  
  DwGLTexture tex_vel_small;
  float[] data_vel;

  public void draw() {    
    
    // update simulation
    fluid.update();
    
    int grid_points = 20;
    
    if(tex_vel_small == null){
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
    for(int gy = 0; gy < grid_points; gy++){
      for(int gx = 0; gx < grid_points; gx++){
        
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
    
    
    // clear render target
    pg_fluid.beginDraw();
    pg_fluid.background(0);
    pg_fluid.endDraw();

    // render fluid stuff
    fluid.renderFluidTextures(pg_fluid, 0);

    // display
    image(pg_fluid, 0, 0);
  }
  

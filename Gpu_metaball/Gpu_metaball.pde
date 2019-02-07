import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

//PostFXSupervisor supervisor;
//SobelPass sobelPass;
//MetaballPass metaballPass;

MetaballParticleSystem mbps;

PShader metaballShader;
PGraphics canvas;

void setup()
{
  size(1500, 500, P3D);

  mbps = new MetaballParticleSystem(); 
  
  metaballShader = loadShader("metaballFrag.glsl", "metaballVert.glsl");
 
}

void draw() {   
  mbps.update();
  mbps.render(this.g);
}


import java.util.ArrayList;
import java.util.Iterator;
MetaBallTest mb;

CVImage img;
PGraphics2D pg;
void setup() {
  size(640, 580, OPENGL); 

  mb = new MetaBallTest(this);

  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION); 


  pg = (PGraphics2D)createGraphics(width, height, P2D);
  //noLoop();
  img = new CVImage(width, height);
}

void draw() {
  background(124);

  pg.beginDraw();
  pg.clear();
  pg.background(0);
  mb.show(pg);
  //pg.ellipse(100,100,100,100);
  pg.endDraw();


  img.copyTo( pg.get() );

  //image(pg, 0, 0);

  ArrayList<MatOfPoint> contours = new ArrayList<MatOfPoint>();
  Mat hierarchy = new Mat();
  Imgproc.findContours(img.getGrey(), contours, hierarchy, 
    Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_SIMPLE);
  //Imgproc.RETR_EXTERNAL
  //Imgproc.RETR_FLOODFILL
  drawPolygons(contours);
}

void drawPolygons(ArrayList<MatOfPoint> contours) {


  pushStyle();
  strokeWeight(5.6);
  stroke(255);
  Iterator<MatOfPoint> it = contours.iterator();
  while (it.hasNext()) { 
    MatOfPoint mp = it.next();
    Point [] pts = mp.toArray();
    boolean inside = true;

    Rect r = Imgproc.boundingRect(mp);
    int cx = (int)(r.x + r.width/2);
    int cy = (int)(r.y + r.height/2);
    stroke(255, 165);
    //double result = Imgproc.pointPolygonTest(new MatOfPoint2f(pts), 
    //  new Point(mx, my), false);
    //if (result > 0) {
    //    fill(255, 0, 0);
    //  } else {
    //    noFill();
    //  }

    fill(#884242);
    beginShape();
    for (int i=0; i<pts.length; i++) {
      vertex((float)pts[i].x, (float)pts[i].y);
    }
    endShape(CLOSE);
  }
  popStyle();
}

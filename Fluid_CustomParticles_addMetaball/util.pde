
void drawMetaBalls (PGraphics2D pg) {
  mb.show(pg);
  
}


void drawPolygons(ArrayList<MatOfPoint> contours, PGraphics2D pg) {

 
  Iterator<MatOfPoint> it = contours.iterator();
  while (it.hasNext()) { 
    MatOfPoint mp = it.next();
    Point [] pts = mp.toArray();
    boolean inside = true;

    Rect r = Imgproc.boundingRect(mp);
    int cx = (int)(r.x + r.width/2);
    int cy = (int)(r.y + r.height/2);
    
    //double result = Imgproc.pointPolygonTest(new MatOfPoint2f(pts), 
    //  new Point(mx, my), false);
    //if (result > 0) {
    //    fill(255, 0, 0);
    //  } else {
    //    noFill();
    //  }

    pg.fill(64);
    pg.beginShape();
    for (int i=0; i<pts.length; i++) {
      pg.vertex((float)pts[i].x, (float)pts[i].y);
    }
    pg.endShape(CLOSE);
  } 
}

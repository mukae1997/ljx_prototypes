boolean OutOfScreen(PVector p) {
  return (p.y > height-10) || p.y < 10 || p.x < 10 || p.x > width - 10;
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
 
    pg.beginShape();
    for (int i=0; i<pts.length; i++) {
      pg.vertex((float)pts[i].x, (float)pts[i].y);
    }
    pg.endShape(CLOSE);
  } 
}

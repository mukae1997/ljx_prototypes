
void mouseMoved() {
}

void mousePressed() {
  //add Atrraction
  for ( int i = 0; i < others.length; i++ ) {
    physics.makeAttraction( mouse, others[i], -500, 0.15 );
  }
  mouse.position().set( mouseX, mouseY, 0 );
}

void mouseDragged() {
  mouse.position().set( mouseX, mouseY, 0 );
}

void mouseReleased() {
  for ( int i = 0; i < physics.numberOfAttractions(); i++ ) {
    Attraction t = physics.getAttraction(i);
    t.setStrength(-200);
  }

  for ( int i = 0; i < physics.numberOfAttractions(); i++ ) {
    physics.removeAttraction(i);
  }
}

void keyPressed() {
  if (keyCode == ' ') {
    WHITE = !WHITE;
  }

  if (keyCode == 'I') {
    USE_IMG = !USE_IMG;
  }

  if (keyCode == 'C') {

    spiral=!spiral;
    timer.reset();
  }
}

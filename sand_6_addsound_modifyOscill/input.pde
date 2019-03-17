
void mouseMoved() {
}

void mousePressed() {
  //add Atrraction
  //for ( int i = 0; i < others.length; i++ ) {
  //  physics.makeAttraction( mouse, others[i], -500, 0.15 );
  //}
  //mouse.position().set( mouseX, mouseY, 0 );


  //expandTimer.reset();
}

void mouseDragged() {
  mouse.position().set( mouseX, mouseY, 0 );
}

void mouseReleased() {

  oscillTimer.reset();

  //for ( int i = 0; i < physics.numberOfAttractions(); i++ ) {
  //  Attraction t = physics.getAttraction(i);
  //  t.setStrength(-200);
  //}

  //for ( int i = 0; i < physics.numberOfAttractions(); i++ ) {
  //  physics.removeAttraction(i);
  //}

  unknown_factor = random(6, 12);
  //unknown_factor = 1;
  println(unknown_factor);
}

void mouseClicked() {
  ratioForSave=1;
  int choice = int(random(1, 5));

  if (choice == 1)
    drop1.trigger();
  else if (choice == 2)
    drop2.trigger();
  else if (choice == 3)
    drop3.trigger();
  else if (choice == 4)
    drop4.trigger();
}

void keyPressed() {
  if (keyCode == ' ') {
    WHITE = !WHITE;
  }

  if (keyCode == 'D') {
    moverDEBUG = !moverDEBUG;
  }
  if (keyCode == 'I') {
    USE_IMG = !USE_IMG;
  }

  if (keyCode == 'C') { 
    spiral=!spiral;
    oscillTimer.reset();
  }
}


void randomlyRemoveSpring() {
  physics.removeSpring(floor(random(0, physics.numberOfSprings())));
}

float SPRING_STRENGTH = 0.01;
float SPRING_DAMPING = 0.1;
float spring_looseness = 2; // bigger, looser
void addAllSprings() {

  int ptr = 0; 
  for ( int i = 0; i < movers.size(); ++i )

  {
    Particle p = movers.get(i);

    Particle q = anchors.get(i); // fixed anchor
    q.position().set(p.position());

    q.makeFixed(); 
    // 让绳子归位
      //physics.makeAttraction(q, p, 500, 5); // 吸引式归位
    physics.makeSpring(q, p, SPRING_STRENGTH, SPRING_DAMPING, 
      spring_looseness); // 并且给出一个attract关系
  }
}
void removeAllSprings() {
  for (int i = physics.numberOfSprings()-1; i >= 0; i--) {
    physics.removeSpring(i);
  }

  for (Particle q : anchors) {
    q.makeFixed();
  }
}

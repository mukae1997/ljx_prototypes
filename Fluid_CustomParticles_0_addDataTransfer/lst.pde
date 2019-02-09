class lifeStateTimer {

  private float state = 0;
  boolean isDead = false;
  float startTime = 0;
  float lifeSpan = 3.0;

  lifeStateTimer(float ls) {
    lifeSpan = ls;
    reset();
  }
  boolean isDead() {
    return isDead;
  }

  void reset() {
    state = 0;
    startTime = millis();
    isDead = false;
  }

  void update() {
    if (isDead) return ;
    state = (millis() - startTime) * 0.001 / lifeSpan; 
    isDead = state > 1;
    state = min(state, 1);
  }

  float getState() {
    return state;
  }
}

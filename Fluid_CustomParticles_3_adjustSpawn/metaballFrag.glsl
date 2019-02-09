#define METABLL_NUM 15 // MUST modify along with 'metaball.pde'

uniform vec4 metaballs[METABLL_NUM];
uniform  float WIDTH;
uniform  float a;
uniform  float HEIGHT;

void main(){
    vec4 a1 = metaballs[0];
    float x = gl_FragCoord.x;
    float y = gl_FragCoord.y;
    float v = 0.0;
    for (int i = 0; i < METABLL_NUM; i++) {
        
        vec4 mb = metaballs[i];
        if (mb.w >= 1.0) continue;
        float dx = mb.x - x;
        float dy = mb.y - y;
        float r = mb.z * (1.0-mb.w);
        v += r*r/(dx*dx + dy*dy);
    }
    if (v > 1.0 ) {
        gl_FragColor = vec4(vec3(64.0/255.0), max(0.0,  1.0));
    } else {
        gl_FragColor = vec4(0.0);
    } 
}

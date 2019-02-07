#define METABLL_NUM 20

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
        vec3 mb = metaballs[i].xyz;
        float dx = mb.x - x;
        float dy = mb.y - y;
        float r = mb.z;
        v += r*r/(dx*dx + dy*dy);
    }
    if (v > 1.0) { 
        gl_FragColor = vec4(0.0,0.0,0.0,1.0); 
    } else {
        gl_FragColor = vec4(0.0);
    } 
}
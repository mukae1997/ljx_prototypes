#define METABLL_NUM 30

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
        float dy = mb.y - (HEIGHT - y);
        float r = mb.z * (1.0 - metaballs[i].w);
        v += r*r/(dx*dx + dy*dy);
    }

    if (v > 1.0) {  
//        float val = mod(min(10.0, v), 1.0);
//        val = (cos(20/v) + 1.0 ) * 0.5;
        gl_FragColor = vec4(vec3(v - 1.0),0.27);
    } else {
        gl_FragColor = vec4(0.0);
    }  
}

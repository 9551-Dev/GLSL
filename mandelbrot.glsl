precision mediump float;

#define sx 2000.0;

uniform float u_time;
uniform vec2 u_resolution;

void main() {
    vec2 px = gl_FragCoord.xy;

    float sn = abs(sin(u_time)) * sx;

    float dx = (px.x - sn) / sn;
    float dy = (px.y - sn) / sn;
    
    float a = dx;
    float b = dy;
    bool passed = false;

    for (int t=1; t < 2000; t++) {
        float dist =  pow(a,2.0) - pow(b,2.0) + dx;
        b = 2.0*(a*b) + dy;
        a = dist; 
        

        if (dist > 200.0) {
            
            gl_FragColor = vec4(
                t*3 / 256,
                t   / 256,
                t/2 / 256,
                1
            );
            passed = true;
            break;
        }
    }
    if (!passed) {
        gl_FragColor = vec4(0,0,0,1);
    }
}

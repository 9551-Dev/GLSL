precision mediump float;

uniform float u_time;

void main() {

    float tox = abs((sin(u_time)+2.0)*20.0);
    float toy = abs((-cos(u_time)+2.0)*20.0);

    vec2 st = gl_FragCoord.xy/tox;

    float dx = cos(st.x + tox/2.0);
    float dy = sin(st.y + toy/2.0);

    float c  = dx*dy;

    if (c < abs(sin(u_time))) {
        if (c > cos(u_time)/2.0) {
            gl_FragColor = vec4(1,1,1,1);
        } else {
            gl_FragColor = vec4(0,0,0,1);
        }
    } else {
        gl_FragColor = vec4(0,0,0,1);
    }
}

precision mediump float;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

void main() {
    vec2 pix = gl_FragCoord.xy/u_resolution;
    vec2 ms  = u_mouse/u_resolution;

    float d = 1.0-sqrt(pow(pix.x-ms.x,2.0) + pow(pix.y-ms.y,2.0))*5.0;

    float shade = abs(sin(u_time))*2.0+1.0;

    gl_FragColor = vec4(
        d*shade,d*shade,d*shade,1
    );
}

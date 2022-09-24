precision mediump float;

uniform vec2 u_resolution;

void main() {
    vec2 pix = gl_FragCoord.xy;

    float cx = mod(pix.x,200.0)/u_resolution.x;
    float cy = mod(pix.y,200.0)/u_resolution.y;

    float c = cx+cy;

    c = smoothstep(0.0,0.5,c);

    gl_FragColor = vec4(c,c,c,1);
}

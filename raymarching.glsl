precision mediump float;

#define EPSILON (1e-4)

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

struct Ball {
    vec3 pos;
    float radius;
};

struct Scene {
    float dist;
    vec4 color;
};

struct Hit {
    float dist;
    vec4 color;
    vec3 normal;
    vec3 pos;
};

Ball ball1 = Ball(vec3(500,500,0),100.0);
Ball ball2 = Ball(vec3(500,500,0),100.0);

float lenght(vec3 v) {
    return sqrt(pow(v.x,2.0)+pow(v.y,2.0)+pow(v.z,2.0));
}

float get_dist(vec3 p,vec3 centre,float radius) {
    return mod(lenght(centre-p) - radius,2000.0);
}

float smin(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

vec4 csmin(float a, float b, float k, vec4 c1, vec4 c2) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(c1,c2,h);
}

vec3 light = vec3(500,0,0);

Scene get_dist_to_scene(vec3 p) {
    float dist1 = get_dist(p,ball1.pos,ball1.radius);
    float dist2 = get_dist(p,ball2.pos,ball2.radius);

    float dist = smin(dist1,dist2,500.0);

    vec4 c = csmin(dist1,dist2,500.0,
        vec4(0.0,0.0,1.0,1.0),
        vec4(1.0,0.0,0.0,1.0)
    );

    return Scene(dist,c);
}

vec3 get_normal(vec3 p, float dist) {
    return normalize(vec3(
        get_dist_to_scene(p + vec3(EPSILON,0,0)).dist,
        get_dist_to_scene(p + vec3(0,EPSILON,0)).dist,
        get_dist_to_scene(p + vec3(0,0,EPSILON)).dist
    )-dist);
}

Hit raymarch(vec3 p, vec3 dir) {

    vec3 origin = p;

    Hit hit;
    hit.dist = -1.0;

    float new_dist = 0.0;

    for (int i=1; i<10; i++) {
        p += new_dist*dir;

        Scene scene = get_dist_to_scene(p);
        new_dist = scene.dist;

        if (new_dist < EPSILON) {
            hit.dist = distance(origin,p);
            hit.color = scene.color;
            hit.normal = get_normal(p,new_dist);
            hit.pos = p;

            break;
        }
    }

    return hit;
}

void main() {
    vec3 dir = vec3(0,0,1);
    vec3 p = vec3(gl_FragCoord.xy,0);
    vec4 clr = vec4(0.0,0.0,0.0,1.0);

    ball1.pos.xy = u_mouse.xy;
    ball2.pos.xy = u_resolution.xy/2.0;

    Hit hit = raymarch(p,dir);

    vec3 light_dir = light-hit.pos;
    vec3 shadow_origin = hit.pos-hit.normal;

    Hit shadow = raymarch(shadow_origin,light_dir);

    if (hit.color.a > 0.1) {
        clr = hit.color;
    }

    if (!(shadow.dist <= 0.0 || shadow.dist >= distance(shadow_origin,light))) {
        clr = vec4(0.0,0.0,0.0,1.0);
    }

    gl_FragColor = clr;

}

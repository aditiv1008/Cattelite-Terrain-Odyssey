precision highp float;
precision highp int;
varying vec4 vPosition;

varying vec4 vColor;
varying vec3 vNormal;
varying vec2 vUv;

uniform float time;
uniform float tscale;
uniform float var1;
uniform float var2;

void main() {
    #ifdef USE_COLOR
    vColor = vec4(color.xyz, 1.0);
    #else
    vColor = vec4(1.0,1.0,1.0,1.0);
    #endif
    vNormal = normalMatrix * normal;
        vec3 modPosition = position.xyz+var1*sin(position.z*var2+time*tscale)*vec3(0.0,1.0,0.0);
//    vec3 modPosition = position.xyz;
    vPosition = modelViewMatrix * vec4(modPosition, 1.0);

    vUv = vec2(uv.x,1.0-uv.y);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(modPosition, 1.0);
}

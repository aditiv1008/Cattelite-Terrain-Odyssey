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
    vec4 position4 = vec4(position.xyz,1.0);
    vPosition = modelViewMatrix * position4;
    gl_Position = projectionMatrix * modelViewMatrix * position4;
    vUv = uv;
}

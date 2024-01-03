precision highp float;
precision highp int;
varying vec4 vPosition;
#ifdef USE_COLOR
varying vec4 vColor;
#endif
varying vec3 vNormal;
varying vec2 vUv;

void main() {
    #ifdef USE_COLOR
    vColor = color;
    #endif

    vPosition = modelViewMatrix * vec4(position.xyz, 1.0);
    vNormal = normalMatrix * normal;
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position.xyz , 1.0);
}

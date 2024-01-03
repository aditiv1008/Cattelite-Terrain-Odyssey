precision highp float;
precision highp int;
varying vec2 vUv;
varying vec4 vNDC;

void main() {
    vUv = uv;
    vNDC = projectionMatrix * modelViewMatrix * vec4(position.xyz , 1.0);
    gl_Position = vNDC;
}

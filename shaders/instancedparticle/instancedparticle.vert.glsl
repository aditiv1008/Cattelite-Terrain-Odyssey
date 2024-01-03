precision highp float;
precision highp int;

uniform bool opacityInMatrix;
attribute vec4 color;
varying vec4 vPosition;
varying vec4 vColor;
varying vec3 vNormal;
varying vec2 vUv;



void main() {
    vColor = vec4(instanceColor.xyz,1);
    mat4 instanceMatrixUse = instanceMatrix;
    if(opacityInMatrix){
        vColor.a = 1.0-instanceMatrixUse[0][3];
        instanceMatrixUse[0][3] = 0.0;
    }
    vPosition =  viewMatrix * modelMatrix * instanceMatrixUse * vec4(position.xyz , 1.0);
    vNormal = normalMatrix * normal;
    vUv = uv;
    gl_Position = projectionMatrix * vPosition;
}

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
    // We can use macros in shaders.
    // The one below checks for a THREEJS variable that indicates whether the shader uses color information from the provided model's vertices
    #ifdef USE_COLOR
    vColor = vec4(color.xyz, 1.0);
    #else
    vColor = vec4(1.0,1.0,1.0,1.0);
    #endif
    vNormal = normalMatrix * normal;

    // let's create a variable that represents the position modulated by a sin wave
    vec3 modPosition = position.xyz+var1*0.05*sin(position.z*var2*100.0+time*tscale)*vec3(0.0,1.0,0.0);

    // We will pass a varying vec4 that represents position in the camera's frame of reference
    // this will be interpolated during rasterization to give us a per-fragment value in our fragment shader
    vPosition = modelViewMatrix * vec4(modPosition, 1.0);
    vUv = vec2(uv.x,1.0-uv.y);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(modPosition, 1.0);
}

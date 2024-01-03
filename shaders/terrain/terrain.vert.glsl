precision highp float;
precision highp int;
varying vec4 vPosition;
//#ifdef USE_COLOR
varying vec4 vColor;
//#endif
varying vec3 vNormal;
varying vec2 vUv;

uniform sampler2D diffuseMap;
uniform bool diffuseMapProvided;

uniform sampler2D normalMap;
uniform bool normalMapProvided;

uniform sampler2D heightMap;
uniform bool heightMapProvided;

void main() {
    #ifdef USE_COLOR
    vColor = color;
    #endif

    vec3 dposition = position.xyz;

    if(heightMapProvided){
        float heightOffset = texture(heightMap, uv).x;
        dposition.z = heightOffset;
        vPosition = modelViewMatrix * vec4(dposition, 1.0);
        vNormal = normal;
        vUv = uv;
        gl_Position = projectionMatrix * modelViewMatrix * vec4(dposition, 1.0);
//        gl_Position = projectionMatrix * modelViewMatrix * vec4(uv.x, uv.y, heightOffset, 1.0);
    }else {
        vPosition = modelViewMatrix * vec4(dposition, 1.0);
        vNormal = normalMatrix * normal;
        vUv = uv;
        gl_Position = projectionMatrix * modelViewMatrix * vec4(dposition, 1.0);
    }
}

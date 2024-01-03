precision highp float;
precision highp int;

struct PointLight {
    vec3 color;
    vec3 position; // light position, in camera coordinates
    float distance; // used for attenuation purposes.
    float intensity;
    float decay;
};
uniform PointLight pointLights[NUM_POINT_LIGHTS];

uniform float ambient;

uniform sampler2D diffuseMap;
uniform bool diffuseMapProvided;

uniform sampler2D normalMap;
uniform bool normalMapProvided;

uniform vec4 particleColor;

varying vec4 vPosition;
varying vec3 vNormal;
varying vec2 vUv;
#ifdef USE_COLOR
varying vec4 vColor;
#endif

void main()	{
    vec3 N = normalize(vNormal);
    vec3 position = vPosition.xyz/vPosition.w;
    vec4 surface_color = particleColor;
    gl_FragColor = surface_color;
}

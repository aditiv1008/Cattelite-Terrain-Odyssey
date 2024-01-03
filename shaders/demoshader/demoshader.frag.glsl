precision highp float;
precision highp int;



#if ( NUM_POINT_LIGHTS > 0 )
struct PointLight {
    vec3 color;
    vec3 position; // light position, in camera coordinates
    float distance; // used for attenuation purposes.
    float intensity;
    float decay;
};
uniform PointLight pointLights[NUM_POINT_LIGHTS];
#endif

uniform float ambient;
uniform float diffuse;
uniform float specular;
uniform float specularExp;
uniform float time;
uniform float tscale;
uniform float var1;
uniform float surfaceColoring;

uniform bool useViewLight;

uniform sampler2D diffuseMap;
uniform sampler2D normalMap;
uniform bool diffuseMapProvided;
uniform bool normalMapProvided;

varying vec4 vPosition;
varying vec3 vNormal;
varying vec2 vUv;
#ifdef USE_COLOR
varying vec4 vColor;
#endif



#if ( NUM_POINT_LIGHTS > 0 )

vec3 evalDiffuse(vec3 position, vec3 N, int lightIndex){
    vec4 lightPosition = vec4(pointLights[lightIndex].position, 1.0);
    vec3 lightColor = pointLights[lightIndex].color;
//    vec3 lightColor = vec3(1.0,1.0,1.0);

    // The distance parameter in ThreeJS point lights is actually their range.
//    float lightRange = pointLights[lightIndex].distance;
    float lightRange = 100.0;

    // The decay parameter controls how quickly the light decays over the specified range.
//    float lightDecay = pointLights[lightIndex].decay;
    float lightDecay = 0.0;

    // The falloff is computed like so...
    vec3 pToL = lightPosition.xyz-vPosition.xyz;
    vec3 L = normalize(pToL);

    float diffuseStrength = dot(N,L);
//    float diffuseStrength = 1.0;

    float dist = length(pToL);
    float falloff = max(0.0, 1.0-(dist/lightRange));
    falloff = pow(falloff, lightDecay);
    return diffuseStrength*lightColor;
//    return diffuseStrength*falloff*lightColor;
}

vec3 evalSpecular(vec3 position, vec3 N, int lightIndex){
    vec4 lightPosition = vec4(pointLights[lightIndex].position, 1.0);
    vec3 lightColor = pointLights[lightIndex].color;
    float lightDistance = pointLights[lightIndex].distance;
    float lightDecay = pointLights[lightIndex].decay;
    vec3 pToL = lightPosition.xyz-vPosition.xyz;

    vec3 L = normalize(pToL);
    vec3 vertexToEye = normalize(-position);
    vec3 lightReflect = normalize(reflect(-L, N));
    float specularFactor = max(dot(vertexToEye, lightReflect), 0.0);
    return lightColor*pow(specularFactor, specularExp);;
}
#endif


void main()	{
    vec3 n = normalize(vNormal);
    vec3 p = vPosition.xyz/vPosition.w;
    vec4 surface_color = surfaceColoring*vColor+(1.0-surfaceColoring)*vec4(1.0,1.0,1.0,1.0);
    if(diffuseMapProvided){
        surface_color = surface_color*texture(diffuseMap, vUv);
    }else{
        surface_color;
    }

    vec3 specularLighting = vec3(0.0,0.0,0.0);
    vec3 diffuseLighting = vec3(0.0,0.0,0.0);
    vec3 lighting;

#if ( NUM_POINT_LIGHTS > 0 )
//    diffuseLighting = diffuseLighting+evalDiffuse(p,n,0);
    int startLight = 1;
    if(useViewLight){
        startLight=0;
    }
    for (int lightIndex=startLight;lightIndex<int(NUM_POINT_LIGHTS);++lightIndex){
        specularLighting = specularLighting+evalSpecular(p,n,lightIndex);
        diffuseLighting = diffuseLighting+evalDiffuse(p,n,lightIndex);
    }
    lighting = diffuseLighting*surface_color.xyz*diffuse+specularLighting*specular + surface_color.xyz*vec3(ambient, ambient,ambient);
#else
    // If all red that means you probably didn't add any point lights
    lighting = vec3(1.0,0.0,0.0);
#endif


    gl_FragColor = vec4(lighting,surface_color.w);
    //    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
//    gl_FragColor = vec4(n, 1.0);
//    gl_FragColor = vec4(surface_color.xyz, 1.0);

//    gl_FragColor = vec4(diffuse, diffuse, diffuse, 1.0);
//    gl_FragColor = vec4(specular, specular, specular, 1.0);
}

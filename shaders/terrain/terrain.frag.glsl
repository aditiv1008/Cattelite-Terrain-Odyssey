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

uniform vec4 modelColor;
uniform mat4 modelViewMatrix;
uniform float ambient;
uniform float diffuse;
uniform float specular;
uniform float specularExp;
uniform float texCoordScale;
uniform float textureTransition;

uniform sampler2D diffuseMap;
uniform bool diffuseMapProvided;

// Adding an extra texture that we can sample from
uniform sampler2D tex2Map;
uniform bool tex2MapProvided;

uniform sampler2D normalMap;
uniform bool normalMapProvided;

uniform sampler2D heightMap;
uniform bool heightMapProvided;


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

    // The distance parameter in ThreeJS point lights is actually their range.
    float lightRange = pointLights[lightIndex].distance;

    // The decay parameter controls how quickly the light decays over the specified range.
    float lightDecay = pointLights[lightIndex].decay;

    // The falloff is computed like so...
    vec3 pToL = lightPosition.xyz-vPosition.xyz;
    vec3 L = normalize(pToL);

    float diffuseStrength = dot(N,L);

    float dist = length(pToL);
    float falloff = max(0.0, 1.0-(dist/lightRange));
    falloff = pow(falloff, lightDecay);
    return lightColor;
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
    vec3 N = normalize( cross( dFdx( vPosition.xyz ), dFdy( vPosition.xyz ) ) );
    vec3 position = vPosition.xyz/vPosition.w;
    vec4 surface_color = texture(diffuseMap, vUv*texCoordScale);


    // If the user provided a tex2 texture then we will render the x>0 part of the terrain using that
    if(tex2MapProvided && vPosition.x > textureTransition*texCoordScale){
        surface_color = texture(tex2Map, vUv*texCoordScale);
    }
    float alpha = 1.0;

    vec3 specularLighting = vec3(0.0,0.0,0.0);
    vec3 diffuseLighting = vec3(0.0,0.0,0.0);
    vec3 outColor = vec3(0.0,0.0,0.0);

    #if ( NUM_POINT_LIGHTS > 0 )
    for (int lightIndex=0;lightIndex<int(NUM_POINT_LIGHTS);++lightIndex){
        specularLighting = specularLighting+evalSpecular(position,N,lightIndex);
        diffuseLighting = diffuseLighting+evalDiffuse(position,N,lightIndex);
    }
    outColor = diffuseLighting*surface_color.xyz*diffuse+specularLighting*specular + vec3(ambient, ambient,ambient);
    #else
    // If all red that means you probably didn't add any point lights
    outColor = vec3(1.0,0.0,0.0);
    #endif

    gl_FragColor = vec4(outColor,surface_color.w);
}

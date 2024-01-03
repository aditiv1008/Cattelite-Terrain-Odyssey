precision highp float;
precision highp int;

uniform sampler2D particleMap;
uniform bool particleMapProvided;

varying vec4 vPosition;
varying vec4 vColor;
varying vec2 vUv;


void main()	{
    vec3 position = vPosition.xyz/vPosition.w;
    vec4 surface_color = vColor;
    if(particleMapProvided){
        surface_color = surface_color*texture(particleMap, vUv).xyzw;
    }
//    gl_FragColor = vec4(0.0,1.0, 0.0, 1.0);
    gl_FragColor = surface_color;
}

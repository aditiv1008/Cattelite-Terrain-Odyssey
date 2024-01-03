precision highp float;
precision highp int;

uniform sampler2D diffuseMap;
uniform bool diffuseMapProvided;
varying vec4 vPosition;
varying vec2 vUv;

void main()	{
    vec4 textureColor = texture(diffuseMap, vUv);
    gl_FragColor = textureColor;
}

precision highp float;
precision highp int;

uniform sampler2D inputMap;
uniform bool inputMapProvided;

uniform float sliderValue;

varying vec4 vPosition;
varying vec2 vUv;
varying vec4 vNDC;
uniform bool useNDCCoords;
uniform bool showTextureCoords;

void main()	{
    // We want to sample from a texture that represents the mirrored world rendered from our current perspective.
    // To do this, let's start by calculating the coordinates of our current fragment.
    // More specifically, we will homogenize our normalized device coordinates to get a value that maps our screen to
    // the x and y ranges [-1,1]
    vec2 currentZeroCenterNormalizedScreenCoordinates = vNDC.xy/vNDC.w;
    // Let's convert these to texture coordinates by shifting and scaling our range to [0,1];
    vec2 textureCoordinates = currentZeroCenterNormalizedScreenCoordinates*0.5+vec2(0.5,0.5);

    if(!useNDCCoords){
        textureCoordinates = vUv;
    }

    // Let's sample the texture
    vec4 textureColor = texture(inputMap, textureCoordinates);

    vec4 outputColor = textureColor;
    if(showTextureCoords){
        outputColor = vec4(textureCoordinates, 0.0, 1.0);
    }

    gl_FragColor = outputColor;
}

precision highp float;
precision highp int;

//uniform float exposure;

uniform sampler2D inputMap;
uniform bool inputMapProvided;
uniform float sliderValue;
varying vec4 vPosition;
varying vec2 vUv;

void main()	{
    float xTextureCoordinateOffset = sin((sliderValue*10.0)*2.0*3.14159*vUv.y)*sliderValue*0.1;

    vec4 inputColor = texture(inputMap, vec2(vUv.x+xTextureCoordinateOffset, vUv.y));
    gl_FragColor = vec4(inputColor.xyz, 1.0);

//    gl_FragColor = vec4(vUv.xy, 0.0, 1.0); // comment out this line to display a visualization of texture coordinates
//    gl_FragColor = vec4(1.0,0.0,0.0,1.0);
}

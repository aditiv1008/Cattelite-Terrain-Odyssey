precision highp float;
precision highp int;
uniform mat4 modelViewMatrix;
varying vec4 vPosition;
varying vec4 vColor;
varying vec3 vNormal;


void main()	{
//    gl_FragColor = vec4(0.0,1.0,0.0,1.0);
    gl_FragColor = vColor;
}

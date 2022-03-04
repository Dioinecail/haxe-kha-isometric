#version 450

in vec2 vUV;
in vec3 fColor;

uniform sampler2D tex2D;

out vec4 col;

void main() {
    vec4 texColor = texture(tex2D, vUV);
    col = vec4(texColor.r, texColor.g, texColor.b, 1.0);
    // col = vec4(1, 0, 0, 1);
}
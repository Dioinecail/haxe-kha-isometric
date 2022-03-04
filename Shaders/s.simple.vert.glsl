#version 450

// Input vertex data, different for all executions of this shader
in vec3 pos;
in vec2 uv;

in vec3 tint;
uniform mat4 m;

// Output data
out vec2 vUV;
out vec3 fColor;



void main() {
	gl_Position = m * vec4(pos, 1.0);

	vUV = uv;
	fColor = tint;
}

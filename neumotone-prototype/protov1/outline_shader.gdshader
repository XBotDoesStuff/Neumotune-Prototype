shader_type spatial;
render_mode unshaded;

uniform vec4 outline_color: source_color;
uniform float outline_strength = 100.0;

void fragment() {
    ALBEDO = outline_color.rgb;
    ALPHA = dot(NORMAL, vec3(0,0,1)) * outline_strength;
	METALLIC = 1.0;
}
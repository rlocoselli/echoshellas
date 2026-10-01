shader_type canvas_item;

uniform vec4 shadow_color : hint_color = vec4(0.18, 0.29, 0.30, 1.0);
uniform vec4 stone_color : hint_color = vec4(0.88, 0.83, 0.65, 1.0);
uniform float strength = 0.8;

void fragment() {
	vec4 source = texture(TEXTURE, UV);
	float value = dot(source.rgb, vec3(0.299, 0.587, 0.114));
	// Keep the original pixel clusters and outlines; change the stone palette.
	vec3 stone = mix(shadow_color.rgb, stone_color.rgb, smoothstep(0.04, 0.78, value));
	COLOR = vec4(mix(source.rgb, stone, strength), source.a) * COLOR;
}

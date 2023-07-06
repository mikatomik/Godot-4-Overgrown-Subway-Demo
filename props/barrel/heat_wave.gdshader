shader_type spatial;
render_mode unshaded, cull_back;

uniform sampler2D screen_tex : hint_screen_texture;
uniform sampler2D distortion_noise;

void vertex() {
	//Billboard plane
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	//Setup scrolling UV to sample noise tex with
	vec2 noise_uv = vec2(UV.x, UV.y + TIME * 0.5);
	float n = texture(distortion_noise, noise_uv).r * 0.01;
	
	//make new UV and distort them using the noise sampled above
	vec2 distort_uv = SCREEN_UV + n;
	
	//Draw a circle to use as an alpha mask
	float m = distance(vec2(0.5), UV);
	m = 1.0 - smoothstep(0.2, 0.3, m); 
	
	ALBEDO = texture(screen_tex, distort_uv).rgb;
	ALPHA = m;
}

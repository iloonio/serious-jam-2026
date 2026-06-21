// NOTE: Shader automatically converted from Godot Engine 4.7.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_schlick_ggx;

uniform float hide_factor : hint_range(0.0, 1.0);

uniform vec4 albedo : source_color;

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform ivec2 albedo_texture_size;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

// for cutting grass 
varying flat vec4 custom_data;
varying vec3 local_pos;

// for wind
uniform float wind_speed = 2.0;
uniform float wind_strength = 0.15;
uniform vec2 wind_direction = vec2(1.0, 0.5);



void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
	
	
	// for cutting grass
	local_pos = VERTEX;
	custom_data = INSTANCE_CUSTOM;
	
	
	// wind logic
	
    // world pos from local pos for the offset
    vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    
    // define wave based on time, world position, and wind direction
    float wave = sin(TIME * wind_speed + (world_pos.x * wind_direction.x + world_pos.z * wind_direction.y));
	
	
    // use UV.y as mask (1.0 is at the base)
    float wind_mask = 1.0 - UV.y; 
    
    // apply displacement
    VERTEX.x += wave * wind_strength * wind_mask;
    VERTEX.z += wave * wind_strength * wind_direction.y * wind_mask ;
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	
	
	// for cutting grass
	if (local_pos.y > 0.5 && custom_data.x > 0.5) {
        discard;
    } 
}

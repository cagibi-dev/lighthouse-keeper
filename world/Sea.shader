shader_type canvas_item;

uniform vec2 amplitude = vec2(0.0, 10.0);
uniform float speed = 1.0;

/*void fragment() {
	COLOR = texture(TEXTURE, vec2(UV.y, UV.x));
	COLOR.b = 1.0;
}*/

void vertex() {
  // Animate Sprite moving in big circle around its location
  VERTEX += vec2(cos(TIME*speed)*amplitude.x, sin(TIME*speed)*amplitude.y);
}
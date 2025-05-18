package main

import "core:math"

rotate :: proc(vector: Vec2, angle: f32) -> Vec2 {
	new_x:= vector.x * math.cos(angle) - vector.y * math.sin(angle)
	new_y:= vector.x * math.sin(angle) + vector.y * math.cos(angle)
	return {new_x,new_y}
}

normalize :: proc(vector: $T/[$dimensions]f32) -> T {
	return vector / mag(vector)
}

lerp :: proc {
	lerp_vec,
	lerp_float
}

lerp_float :: proc(a: f32, b: f32, d: f32) -> f32 {
	return a * (1.0 - d) + (b * d)
}

lerp_vec :: proc(a: $T/[$dimensions]f32, b: T, d: f32) -> T {
	return a * (1.0 - d) + (b * d)
}


chop :: proc(vector: Vec3) -> Vec2 {
	return [2]f32{vector.x, vector.y}
}

extend :: proc(vector: Vec2, z: f32) -> Vec3 {
	return [3]f32{vector.x, vector.y, z}
}

mag :: proc(vector: $T/[$dimensions]f32) -> f32 {
	result: f32
	for i in 0..<dimensions {
		result += vector[i]*vector[i]
	}
	return math.sqrt(result)
}

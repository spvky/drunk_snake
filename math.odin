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


mag :: proc(vector: $T/[$dimensions]f32) -> f32 {
	assert(dimensions > 1 && dimensions < 5)
	result: f32
	for i in 0..<dimensions {
		result += vector[i]*vector[i]
	}
	return math.sqrt(result)
}

distance :: proc(a: $T/[$dimensions]f32, b: T) -> f32 {
	return mag(b - a)
}

interpolate_point :: proc(transform: Transform, point: Vec2) -> Vec2 {
	x_axis := rotate({1,0}, transform.rotation)
	y_axis := rotate({0,1}, transform.rotation)
	return transform.translation + (x_axis * point.x) + (y_axis * point.y)
}

rotation_axes :: proc(transform: Transform) -> (x_axis: Vec2, y_axis: Vec2) {
			return
}

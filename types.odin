package main

import rl "vendor:raylib"

Vec2 :: [2]f32
Triangle :: [3]Vec2
Vec3 :: [3]f32

Character :: enum {
	enemy,
	player
}

Player :: struct {
	points: [3]Vec2,
	using transform: Transform,
	position_timer: f32,
	target_speed: f32,
	speed: f32,
	target_turnspeed: f32,
	turnspeed: f32,
	quadrant: Quadrant,
}

Segment :: struct {
	using transform: Transform,
	height: f32,
	move_index: int
}

Transform :: struct {
	using translation: Vec2,
	rotation: f32
}

Pickup :: struct {
	using transform: Transform,
}

TestStruct :: struct {
	val: int
}

Quadrant :: enum {
	NE,
	NW,
	SE,
	SW
}

// Struct that contains all of the data in the game world
World :: struct {
	player: Player,
	segments: [dynamic]Segment,
	pickup: Transform,
	collision_triangles: [dynamic]Triangle,
	is_alive: bool
}

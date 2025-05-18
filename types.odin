package main

import rl "vendor:raylib"

Vec2 :: [2]f32
Vec3 :: [3]f32

Character :: enum {
	enemy,
	player
}

Player :: struct {
	points: [3]Vec2,
	color: rl.Color,
	using transform: Transform
}

Segment :: struct {
	using transform: Transform,
	height: f32
}

Transform :: struct {
	using translation: Vec2,
	rotation: f32
}

Pickup :: struct {
	using transform: Transform,
}

World :: struct {
	player: Player,
	segments: [dynamic]Segment,
	pickups: [dynamic]Pickup
}

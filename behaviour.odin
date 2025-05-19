package main

import rl "vendor:raylib"

update :: proc(world: ^World, frametime: f32) {
	player : ^Player = &world.player
	player.animation_progress += frametime;
	if player.animation_progress > 1 {
		player.animation_progress = 0
		spawn_segment(world)
	}
	player.position_timer += frametime;
	if player.position_timer > 0.5 {
		player.position_timer = 0
		track_position(world)
	}

	y_axis:= rotate({0,1}, player.rotation)
	if rl.IsKeyDown(.D) {player.rotation += 2.5 * frametime}
	if rl.IsKeyDown(.A) {player.rotation -= 2.5 * frametime}
	player.translation += (y_axis * 100) * frametime
}

segment_movement :: proc(world: ^World) {
	for &segment, i in world.segments {
		if i == 0 {
			
		}
	}
}

lerp_transform :: proc(transform: ^Transform, target_transform: Transform, delta: f32) {
	transform.translation = lerp(transform.translation, target_transform.translation, delta)
	transform.rotation = lerp(transform.rotation, target_transform.rotation, delta)
}

spawn_segment :: proc(world: ^World) {
	if len(world.segments) < 5 {
		player : ^Player = &world.player
		append(&world.segments, Segment{ transform = player.transform})
	}
}

track_position :: proc(world: ^World) {
	player: ^Player = &world.player
	append(&world.positions, player.transform)
}

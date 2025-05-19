package main

import "core:fmt"
import rl "vendor:raylib"

update :: proc(world: ^World, frametime: f32) {
	player : ^Player = &world.player
	player.animation_progress += frametime;
	if player.animation_progress > 1.5 {
		player.animation_progress = 0
		spawn_segment(world)
	}
	player.position_timer += frametime;
	if player.position_timer > 0.5 {
		player.position_timer = 0
	}
	// segment_movement(world, frametime)
	simple_segment_movement(world, frametime)

	y_axis:= rotate({0,1}, player.rotation)
	if rl.IsKeyDown(.D) {player.rotation += 2.5 * frametime}
	if rl.IsKeyDown(.A) {player.rotation -= 2.5 * frametime}
	player.translation += (y_axis * 100) * frametime
}

simple_segment_movement :: proc(world: ^World, frametime: f32) {
	for &segment, i in world.segments {
		segments_len := len(world.segments)
		target: Transform

		if i == segments_len - 1 {
			target = world.player.transform
		} else {
			target = world.segments[i+1].transform
		}
		target_distance := distance(segment.translation, target.translation)
		segment.translation = lerp(segment.translation, target.translation, frametime)
		// if target_distance < 5 {
			segment.rotation = lerp(segment.rotation, target.rotation, frametime)
		// }
	}
}

lerp_transform :: proc(transform: ^Transform, target_transform: Transform, delta: f32) {
	transform.translation = lerp(transform.translation, target_transform.translation, delta)
	transform.rotation = lerp(transform.rotation, target_transform.rotation, delta)
}

spawn_segment :: proc(world: ^World) {
		player : ^Player = &world.player
		append(&world.segments, Segment{ transform = player.transform})
}

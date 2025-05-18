package main

import rl "vendor:raylib"

update :: proc(world: ^World, frametime: f32) {
	player : ^Player = &world.player
	player.animation_progress += frametime;
	if player.animation_progress > 1 {
		player.animation_progress = 0
		spawn_segment(world)
	}
	frametime:=rl.GetFrameTime()
	y_axis:= rotate({0,1}, player.rotation)
	if rl.IsKeyDown(.D) {player.rotation += 5 * frametime}
	if rl.IsKeyDown(.A) {player.rotation -= 5 * frametime}
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
	player : ^Player = &world.player
	append(&world.segments, Segment{ transform = player.transform})
}

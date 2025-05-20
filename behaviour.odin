package main

import "core:fmt"
import rl "vendor:raylib"

update :: proc(world: ^World, frametime: f32) {
	if world.is_alive {
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
		segment_movement(world, frametime)
		set_collision_triangles(world)
		y_axis:= rotate({0,1}, player.rotation)
		if rl.IsKeyDown(.D) {player.rotation += 2.5 * frametime}
		if rl.IsKeyDown(.A) {player.rotation -= 2.5 * frametime}
		player.translation += (y_axis * 100) * frametime
		kill_player(world)
	}
}

segment_movement :: proc(world: ^World, frametime: f32) {
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
		segment.rotation = lerp(segment.rotation, target.rotation, frametime)
	}
}

spawn_segment :: proc(world: ^World) {
		player : ^Player = &world.player
		segment_len: = len(world.segments)
		if segment_len > 0 {
			last_segment := world.segments[segment_len - 1]
			append(&world.segments, Segment{ transform = last_segment.transform})
		} else {
			spawn_point := interpolate_point(player.transform, {0,-20})
			append(&world.segments, Segment{ transform = {translation = spawn_point, rotation = player.rotation}})
		}
}

kill_player ::proc(world: ^World) {
	nose := interpolate_point(world.player.transform, {0, 30})

	if nose.x > SCREEN_WIDTH || nose.x < 0 || nose.y > SCREEN_HEIGHT || nose.y < 0 {
		world.is_alive = false
	}

	for t in world.collision_triangles {
		if rl.CheckCollisionPointTriangle(nose, t[0], t[1], t[2]) {
			world.is_alive = false
			break
		}
	}
}

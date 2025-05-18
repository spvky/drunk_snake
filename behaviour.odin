package main

import rl "vendor:raylib"

update :: proc(world: ^World) {

	player : ^Player = &world.player
	frametime:=rl.GetFrameTime()
			y_axis:= rotate({0,1}, player.rotation)

			if rl.IsKeyDown(.D) {player.rotation += 10 * frametime}
			if rl.IsKeyDown(.A) {player.rotation -= 10 * frametime}
			if rl.IsKeyDown(.S) {player.translation -= (y_axis * 70) * frametime}
			if rl.IsKeyDown(.W) {player.translation += (y_axis * 100) * frametime}
		}


lerp_transform :: proc(transform: ^Transform, target_transform: Transform, delta: f32) {
	transform.translation = lerp(transform.translation, target_transform.translation, delta)
	transform.rotation = lerp(transform.rotation, target_transform.rotation, delta)
}

package main

import rl "vendor:raylib"

draw :: proc(world: World, frametime: f32) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.Color{255,229,180,1})
	draw_player(world.player)
	draw_segments(world)
	defer rl.EndDrawing()
}


draw_player :: proc(player: Player) {
		points: [8]Vec2 = {
			//First large tri
			{-15,-30},
			{15, -30},
			{0, 30},
			//Second large tri
			{-15,30},
			{15, 30},
			{0, -30},
			//Mid points
			{-30,0},
			{30,0},
		}

		eyes: [2]Vec2 = {
			{-23,12},
			{23,12}
		}

		x_axis:= rotate({1,0}, player.rotation)
		y_axis:= rotate({0,1}, player.rotation)
		for point, i in points {
			/*
				points[i] = player.center + (x_axis * point.x) + (y_axis + point.y)
				will give a fun pseudo 3d rotation
			*/
			points[i] = player.translation + (x_axis * point.x) + (y_axis * point.y)
		}

		for eye, i in eyes {
			eyes[i] = player.translation + (x_axis * eye.x) + (y_axis * eye.y)
		}

		rl.DrawCircleV(eyes[0],7,rl.BLACK)
		rl.DrawCircleV(eyes[1],7,rl.BLACK)

		rl.DrawTriangle(points[2], points[1], points[0], PLAYER_COLOR)
		rl.DrawTriangle(points[3], points[4], points[5], PLAYER_COLOR)
		rl.DrawTriangle(points[7], points[1], points[4], PLAYER_COLOR)
		rl.DrawTriangle(points[3], points[0], points[6], PLAYER_COLOR)
		rl.DrawTriangle(points[7], points[0], points[3], PLAYER_COLOR)
		rl.DrawTriangle(points[4], points[1], points[6], PLAYER_COLOR)
}

draw_segments :: proc(world: World) {
	player_x_axis:= rotate({1,0}, world.player.rotation)
	player_y_axis:= rotate({0,1}, world.player.rotation)
	player_translation:=  world.player.translation

	bottom_2: [2]Vec2
	for segment, seg_i in world.segments {
		x_axis:= rotate({1,0}, segment.rotation)
		y_axis:= rotate({0,1}, segment.rotation)
		
		points: [4]Vec2 = {
			{-15,-20},
			{15,-20},
			{15,20},
			{-15,20}
		}

		for point, i in points {
			points[i] = segment.translation + (x_axis * point.x) + (y_axis * point.y)
		}

		// Draw the main block of the segment
		rl.DrawTriangle(points[2],points[1], points[0], PLAYER_COLOR)
		rl.DrawTriangle(points[3],points[2], points[0], PLAYER_COLOR)

		//Draw the blocks connecting the segments
		if seg_i == len(world.segments) -1 {
			bottom_2 = {
				player_translation + (player_x_axis * 15) + (player_y_axis * -30),
				player_translation + (player_x_axis * -15) + (player_y_axis * -30),
			}
		}

		rl.DrawTriangle(points[0], points[1], bottom_2[1], PLAYER_COLOR)
		rl.DrawTriangle(bottom_2[1], bottom_2[0], points[0], PLAYER_COLOR)

		bottom_2 = {points[3], points[2]}
	}
}

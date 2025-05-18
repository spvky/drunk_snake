package main

import rl "vendor:raylib"

draw :: proc(world: World, frametime: f32) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	draw_player(world.player)
	defer rl.EndDrawing()
}


draw_player :: proc(player: Player) {
		points: [8]Vec2
		raw_points: [8]Vec2 = {
			//First large
			{-15,-30},
			{15, -30},
			{0, 30},
			//Second large
			{-15,30},
			{15, 30},
			{0, -30},
			//Mid points
			{-30,0},
			{30,0},
		}

		x_axis:= rotate({1,0}, player.rotation)
		y_axis:= rotate({0,1}, player.rotation)
		for point, i in raw_points {
			/*
				points[i] = player.center + (x_axis * point.x) + (y_axis + point.y)
				will give a fun pseudo 3d rotation
			*/
			points[i] = player.translation + (x_axis * point.x) + (y_axis * point.y)
		}

		rl.DrawTriangle(points[2], points[1], points[0], player.color)
		rl.DrawTriangle(points[3], points[4], points[5], player.color)
		rl.DrawTriangle(points[7], points[1], points[4], player.color)
		rl.DrawTriangle(points[3], points[0], points[6], player.color)
		// Figure out how to draw this rectangle correctly
		rl.DrawRectanglePro(points[0],{30,60}, player.rotation, player.color)
}

draw_segment :: proc(segment: Segment) {

}

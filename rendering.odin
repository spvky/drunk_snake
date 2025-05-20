package main

import rl "vendor:raylib"

draw :: proc(world: World, frametime: f32) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.Color{255,229,180,1})
	draw_player(world.player)
	draw_collision(world)
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

		for point, i in points {
			/*
				points[i] = player.center + (x_axis * point.x) + (y_axis + point.y)
				will give a fun pseudo 3d rotation
			*/
			points[i] = interpolate_point(player.transform, point)
		}

		for eye, i in eyes {
			eyes[i] = interpolate_point(player.transform, eye)
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


draw_collision :: proc(world: World) {
	for t in world.collision_triangles {
		rl.DrawTriangle(t[0],t[1],t[2],PLAYER_COLOR)
	}
}

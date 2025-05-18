package main

import rl "vendor:raylib"

draw :: proc(world: World) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	draw_player(world.player)
	defer rl.EndDrawing()
}


draw_player :: proc(player: Player) {
		points: [3]Vec2
		x_axis:= rotate({1,0}, player.rotation)
		y_axis:= rotate({0,1}, player.rotation)
		for point, i in player.points {
			/*
				points[i] = player.center + (x_axis * point.x) + (y_axis + point.y)
				will give a fun pseudo 3d rotation
			*/
			points[i] = player.translation + (x_axis * point.x) + (y_axis * point.y)
		}
		rl.DrawTriangle(points[2], points[1], points[0], player.color)
}

draw_segment :: proc(segment: Segment) {

}

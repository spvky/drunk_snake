package main

import "core:fmt"
import rl "vendor:raylib"

draw_apple :: proc(world: World) {
	if apple, pickup_val_ok := world.pickup.?; pickup_val_ok {
		stem_points := [4]Vec2 {
			{5,15},
			{15,20},
			{-5,22.5},
			{25, 17}
		}

		for point,i in stem_points {
			stem_points[i] = interpolate_point(apple, point)
		}
		
		rl.DrawCircleV(apple.translation, 20, rl.RED)
		rl.DrawTriangle(stem_points[2],stem_points[1], stem_points[0], rl.GREEN)
		rl.DrawTriangle(stem_points[2],stem_points[1], stem_points[3], rl.GREEN)
	}
}

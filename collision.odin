package main

import rl "vendor:raylib"

set_collision_triangles :: proc(world: ^World) {
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
			// points[i] = segment.translation + (x_axis * point.x) + (y_axis * point.y)
			points[i] = interpolate_point(segment.transform, point)
		}

		// Draw the main block of the segment

		append(&world.collision_triangles, Triangle{points[2],points[1], points[0]})
		append(&world.collision_triangles, Triangle{points[3],points[2], points[0]})


		if seg_i == len(world.segments) -1 {
		// If last segment, connect to head
			player_points: [2]Vec2 = {
					player_translation + (player_x_axis * -15) + (player_y_axis * -30),
					player_translation + (player_x_axis * 15) + (player_y_axis * -30),
			}
			append(&world.collision_triangles, Triangle{player_points[0], player_points[1], points[2]})
			append(&world.collision_triangles, Triangle{points[2], points[3], player_points[0]})

			append(&world.collision_triangles, Triangle{points[2], player_points[1], player_points[0]})
			append(&world.collision_triangles, Triangle{player_points[0], points[3], points[2]})
		}

		// If first segment, draw tail
		if seg_i == 0 {
			tail_tip:= segment.translation + (x_axis * 0) + (y_axis * -20)
			append(&world.collision_triangles, Triangle{tail_tip, points[1], points[0]})
		} else {
			//Draw the blocks connecting the segments
			append(&world.collision_triangles, Triangle{points[0], points[1], bottom_2[1]})
			append(&world.collision_triangles, Triangle{bottom_2[1], bottom_2[0], points[0]})
		}

		bottom_2 = {points[3], points[2]}
	}
}

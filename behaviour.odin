package main

import "core:fmt"
import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

update :: proc(world: ^World, frametime: f32) {
	if world.is_alive {
		player : ^Player = &world.player
		player.position_timer += frametime;
		if player.position_timer > 0.5 {
			player.position_timer = 0
		}
		rotate_apple(world)
		eat_apple(world)
		segment_movement(world, frametime)
		set_collision_triangles(world)
		update_player_speeds(world, frametime)
		y_axis:= rotate({0,1}, player.rotation)
		if rl.IsKeyDown(.D) {player.rotation += player.turnspeed * frametime}
		if rl.IsKeyDown(.A) {player.rotation -= player.turnspeed * frametime}
		player.translation += (y_axis * player.speed) * frametime
		set_player_quadrant(world)
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
		speed:= world.player.speed / 100
		target_distance := distance(segment.translation, target.translation)
		segment.translation = lerp(segment.translation, target.translation, frametime * speed)
		segment.rotation = lerp(segment.rotation, target.rotation, frametime * speed)
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

update_player_speeds :: proc(world: ^World, frametime: f32) {
	player:= &world.player
	if math.abs(player.speed - player.target_speed) > 1 {
		player.speed = math.lerp(player.speed, player.target_speed, frametime * 5)
		player.turnspeed = math.lerp(player.turnspeed, player.target_turnspeed, frametime * 5)
	} else {
		player.speed = player.target_speed
		player.turnspeed = player.target_turnspeed
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

set_player_quadrant :: proc(world: ^World) {
	player:= &world.player
	half_width:= f32(SCREEN_WIDTH/ 2)
	half_height:= f32(SCREEN_HEIGHT / 2)

	if player.x >= half_width {
		if player.y >= half_height {
			player.quadrant = .NE
		} else {
			player.quadrant = .SE
		}
	} else {
		if player.y >= half_height {
			player.quadrant = .NW
		} else {
			player.quadrant = .SW
		}
	}
}

eat_apple :: proc(world: ^World) {
	nose := interpolate_point(world.player.transform, {0, 30})
	player := &world.player
	if rl.CheckCollisionPointCircle(nose, world.pickup.translation,20) {
		spawn_segment(world)
		player.target_speed *= 1.15
		player.target_turnspeed *= 1.1
		world.pickup.translation = random_position_in_quadrant(new_quadrant(player.quadrant))
	}
}

random_position_in_quadrant :: proc(quadrant: Quadrant) -> Vec2 {
	half_width:= f32(SCREEN_WIDTH/ 2)
	half_height:= f32(SCREEN_HEIGHT / 2)

	x := rand.float32() * (half_width - 200)
	y := rand.float32() * (half_height - 100)

	switch quadrant {
	case .NE:
		x = x + half_width
		y = y + half_height
	case .NW:
		y = y + half_height
	case .SE:
		x = x + half_width
	case .SW:
	}
	return {x,y}
}

new_quadrant :: proc(quadrant: Quadrant) -> Quadrant {
	choices: [3]Quadrant
	switch quadrant {
		case .NE:
			choices = {.NW,.SW,.SE}
		case .NW:
			choices = {.NE,.SW,.SE}
		case .SW:
			choices = {.NE, .NW, .SE}
		case .SE:
			choices = {.NE, .NW, .SW}
	}
	
	return rand.choice(choices[:])
}


rotate_apple :: proc(world: ^World) {
	time:= f32(rl.GetTime())
	apple:= &world.pickup
	apple.rotation = math.PI + math.asin(math.sin(time * 5))
}

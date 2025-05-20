package main

import "core:fmt"
import "core:math"
import "core:mem"
import rl "vendor:raylib"

// Drunken snake
// Figure out segment movement
// add collision with segments
// speed up when getting a pickup
// Add a jump, segments at the jump point are elevated and can be slithered under

SCREEN_WIDTH  :: 1600
SCREEN_HEIGHT :: 900
PLAYER_COLOR :: rl.Color{125,251,152,255}

main :: proc() {
	world: World = {
		player = Player{
			points = {{-10,-20},{10,-20},{0,20}},
			translation = {SCREEN_WIDTH /2, SCREEN_HEIGHT/2},
			rotation = math.PI
		},
		segments = make([dynamic]Segment, 0, 24),
		pickups = make([dynamic]Pickup, 0, 24),
		collision_triangles = make([dynamic]Triangle, 0, 1024,context.temp_allocator),
		is_alive = true
	}

	when ODIN_DEBUG {
		track : mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				for _, entry in track.allocation_map {
					fmt.eprintf("%v leaked %v bytes\n", entry.location, entry.size)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "goofin")
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		frametime := rl.GetFrameTime()
		update(&world, frametime)
		draw(world, frametime)
		free_all(context.temp_allocator)
		clear(&world.collision_triangles)
	}
}


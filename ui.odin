package main

import rl "vendor:raylib"
import "core:fmt"
import s "core:strings"

draw_menu :: proc(world: World) {
	if world.gamestate != .Gameplay {
		rl.DrawRectangleV({0,0},{SCREEN_WIDTH, SCREEN_HEIGHT},{0,0,0,100})
	}
}

draw_score :: proc(world: World) {
	// score_string := fmt.tprintf("%d",world.score)
	// converted_string := s.unsafe_string_to_cstring(score_string)
	
	rl.DrawText(rl.TextFormat("%d", world.score), 1500, 50, 100, rl.BLACK)
}


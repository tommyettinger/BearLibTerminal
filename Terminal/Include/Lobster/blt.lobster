// Copyright 2014 Tommy Ettinger. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// This file should go in lobster/include/ , not in dev/ The functions should
// be pre-defined by the engine if it has been compiled to support BLT.

	/*
	
blt_open() -> int
blt_close()
blt_set(params:string) -> int
blt_refresh()
blt_clear()
blt_clear_area(x:int, y:int, w:int, h:int)
blt_crop(x:int, y:int, w:int, h:int)
blt_layer(index:int)
blt_color(rgba:[float])
blt_bkcolor(rgba:[float])
blt_composition(mode:int)
blt_put(x:int, y:int, code:int)
blt_put_ext(x:int, y:int, dx:int, dy:int, code:int);
blt_pick(x:int, y:int, index:int) -> int
blt_pick_color(x:int, y:int, index:int) -> [float]
blt_pick_bkcolor(x:int, y:int) -> [float]
blt_print(ix:int, y:int, s:string) -> int
blt_measure(s:string) -> int
blt_has_input() -> int
blt_state(code:int) -> int
blt_read() -> int
blt_read_str8(x:int, y:int, max:int) -> string, int
blt_peek() -> int
blt_delay(period:int)
blt_get(key:string, fallback:string) -> string
blt_color_from_name(name:string) -> [float]

	*/



/*
 * Keyboard scancodes for events/states
 */
blt_a :==                0x04
blt_b :==                0x05
blt_c :==                0x06
blt_d :==                0x07
blt_e :==                0x08
blt_f :==                0x09
blt_g :==                0x0A
blt_h :==                0x0B
blt_i :==                0x0C
blt_j :==                0x0D
blt_k :==                0x0E
blt_l :==                0x0F
blt_m :==                0x10
blt_n :==                0x11
blt_o :==                0x12
blt_p :==                0x13
blt_q :==                0x14
blt_r :==                0x15
blt_s :==                0x16
blt_t :==                0x17
blt_u :==                0x18
blt_v :==                0x19
blt_w :==                0x1A
blt_x :==                0x1B
blt_y :==                0x1C
blt_z :==                0x1D
blt_1 :==                0x1E
blt_2 :==                0x1F
blt_3 :==                0x20
blt_4 :==                0x21
blt_5 :==                0x22
blt_6 :==                0x23
blt_7 :==                0x24
blt_8 :==                0x25
blt_9 :==                0x26
blt_0 :==                0x27
blt_return :==           0x28
blt_enter :==            0x28
blt_escape :==           0x29
blt_backspace :==        0x2A
blt_tab :==              0x2B
blt_space :==            0x2C
blt_minus :==            0x2D /*  -  */
blt_equals :==           0x2E /*  =  */
blt_lbracket :==         0x2F /*  [  */
blt_rbracket :==         0x30 /*  ]  */
blt_backslash :==        0x31 /*  \  */
blt_semicolon :==        0x33 /*  ;  */
blt_apostrophe :==       0x34 /*  '  */
blt_grave :==            0x35 /*  `  */
blt_comma :==            0x36 /*  ,  */
blt_period :==           0x37 /*  .  */
blt_slash :==            0x38 /*  /  */
blt_f1 :==               0x3A
blt_f2 :==               0x3B
blt_f3 :==               0x3C
blt_f4 :==               0x3D
blt_f5 :==               0x3E
blt_f6 :==               0x3F
blt_f7 :==               0x40
blt_f8 :==               0x41
blt_f9 :==               0x42
blt_f10 :==              0x43
blt_f11 :==              0x44
blt_f12 :==              0x45
blt_pause :==            0x48 /* Pause/Break */
blt_insert :==           0x49
blt_home :==             0x4A
blt_pageup :==           0x4B
blt_delete :==           0x4C
blt_end :==              0x4D
blt_pagedown :==         0x4E
blt_right :==            0x4F /* Right arrow */
blt_left :==             0x50 /* Left arrow */
blt_down :==             0x51 /* Down arrow */
blt_up :==               0x52 /* Up arrow */
blt_kp_divide :==        0x54 /* '/' on numpad */
blt_kp_multiply :==      0x55 /* '*' on numpad */
blt_kp_minus :==         0x56 /* '-' on numpad */
blt_kp_plus :==          0x57 /* '+' on numpad */
blt_kp_enter :==         0x58
blt_kp_1 :==             0x59
blt_kp_2 :==             0x5A
blt_kp_3 :==             0x5B
blt_kp_4 :==             0x5C
blt_kp_5 :==             0x5D
blt_kp_6 :==             0x5E
blt_kp_7 :==             0x5F
blt_kp_8 :==             0x60
blt_kp_9 :==             0x61
blt_kp_0 :==             0x62
blt_kp_period :==        0x63 /* '.' on numpad */
blt_shift :==            0x70
blt_control :==          0x71

/*
 * Mouse events/states
 */
blt_mouse_left :==       0x80 /* Buttons */
blt_mouse_right :==      0x81
blt_mouse_middle :==     0x82
blt_mouse_x1 :==         0x83
blt_mouse_x2 :==         0x84
blt_mouse_move :==       0x85 /* Movement event */
blt_mouse_scroll :==     0x86 /* Mouse scroll event */
blt_mouse_x :==          0x87 /* Cusor position in cells */
blt_mouse_y :==          0x88
blt_mouse_pixel_x :==    0x89 /* Cursor position in pixels */
blt_mouse_pixel_y :==    0x8A
blt_mouse_wheel :==      0x8B /* Scroll direction and amount */
blt_mouse_clicks :==     0x8C /* Number of consecutive clicks */

/*
 * If key was released instead of pressed, it's code will be bitwise-or'ed with blt_key_released:
 * a) pressed 'A': 0x04
 * b) released 'A': or(0x04, blt_key_released) // equals 0x104
 */
blt_key_released :==     0x100

/*
 * Virtual key-codes for internal terminal states/variables.
 * These can be accessed via blt_state function.
 */
blt_width :==            0xC0 /* Terminal window size in cells */
blt_height :==           0xC1
blt_cell_width :==       0xC2 /* Character cell size in pixels */
blt_cell_height :==      0xC3
blt_color :==            0xC4 /* Current foregroung color */
blt_bkcolor :==          0xC5 /* Current background color */
blt_layer :==            0xC6 /* Current layer */
blt_composition :==      0xC7 /* Current composition state */
blt_char :==             0xC8 /* Translated ANSI code of last produced character */
blt_wchar :==            0xC9 /* Unicode codepoint of last produced character */
blt_event :==            0xCA /* Last dequeued event */
blt_fullscreen :==       0xCB /* Fullscreen state */

/*
 * Other events
 */
blt_closed :==           0xE0
blt_resized :==          0xE1

/*
 * Generic mode enum.
 * Right now it is used for composition option only.
 */
blt_off :==                 0
blt_on :==                  1

/*
 * Input result codes for blt_read function.
 */
blt_input_none :==          0
blt_input_cancelled :==    -1


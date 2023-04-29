/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod
if(room != rm_character_select)
	exit

var _left = keyboard_check_pressed(left_bind_1) or keyboard_check_pressed(left_bind_2);
var _right = keyboard_check_pressed(right_bind_1) or keyboard_check_pressed(right_bind_2);
var _confirm = keyboard_check_pressed(confirm_bind_1) or keyboard_check_pressed(confirm_bind_2) 
	or mouse_check_button_pressed(mb_left);

if(_left)
	selection -= 1;
if(_right)
	selection += 1;
	
if(selection < 0)
	selection = array_length(character_list)-1;
if(selection >= array_length(character_list))
	selection = 0;
	
if(_confirm)
	room_goto_next();
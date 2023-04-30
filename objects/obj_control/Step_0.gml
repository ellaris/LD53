/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod
if(room != rm_character_select)
	exit

var _left = keyboard_check_pressed(left_bind_1) or keyboard_check_pressed(left_bind_2);
var _right = keyboard_check_pressed(right_bind_1) or keyboard_check_pressed(right_bind_2);
var _confirm = keyboard_check_pressed(confirm_bind_1) or keyboard_check_pressed(confirm_bind_2) 
	//or mouse_check_button_pressed(mb_left);

if(_left)
	selection -= 1;
if(_right)
	selection += 1;
	
if(_left or _right)
{
	var _sound = choose(snd_select_1);
	audio_play_sound(_sound,3,false);	
}
	
if(selection < 0)
	selection = array_length(character_list)-1;
if(selection >= array_length(character_list))
	selection = 0;

var _target_angle = animation_angle-animation_angle_change*(selection);
if(_target_angle != animation_value)
{
	animation_value = lerp(animation_value,_target_angle,0.02);
}
	
if(_confirm)
	room_goto_next();
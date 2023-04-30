/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod


with(obj_character)
	draw_line(room_width/2,room_height/2,x,y)	

if(room != rm_character_select)
	exit
	
	
var _default_scale = 4;
for(var i = 0; i < array_length(character_list); i++)
{
	var _spr = object_get_sprite(character_list[i])
	var _offset = selection-i
	var _scale = _default_scale-abs(_offset);
	var _size = sprite_get_width(_spr)*_scale;
	var _xx = room_width/2 + lengthdir_x(room_width/4,animation_value+i*animation_angle_change);
	var _yy = room_height/4 + lengthdir_y(room_height/4,animation_value+i*animation_angle_change);
	var _rot = 0
	_rot = sin(current_time/1000+i)*2;
	if(selection == i)
	{
		
		_scale +=  sin(current_time/1000*2)/10
		// 0 1 2 3 4 5
		// -1 0 1 1 0 -1
		// 0 1 1 0 -1 -1
		// -1 0 1
	}
	
	draw_sprite_ext(_spr,current_second % 2,_xx,_yy,_scale,_scale,_rot,c_white,1);
		
	if(mouse_check_button_pressed(mb_left))
		if(point_in_rectangle(mouse_x,mouse_y,_xx-_size/2,_yy-_size/2,_xx+_size/2,_yy+_size/2))
			if (selection == i)
				room_goto_next()
			else
			{
				selection = i;
				var _sound = choose(snd_select_1);
				audio_play_sound(_sound,3,false);
			}


}
draw_set_halign(fa_middle);
draw_set_valign(fa_center);

draw_text(room_width/2,room_height*0.25/4,"Select Character\n(left click)");
draw_text(room_width/2,room_height*3/4,character_names[selection]);
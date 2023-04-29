/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod
if(room != rm_character_select)
	exit
draw_sprite_stretched(object_get_sprite(character_list[selection]),0,room_width/2,room_height/2,
	room_width/4,room_height/4);

draw_text(room_width/2,room_height*3/4,character_names[selection]);
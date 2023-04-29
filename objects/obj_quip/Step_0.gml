/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

//life -=1
//if( life <= 0)
//	instance_destroy();

life += 1;
if (life > room_speed + string_length(description))
	instance_destroy();
//x = obj_character.x;
//y = obj_character.bbox_top;
/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod
var _char = instance_place(x,y,obj_character);
if(_char and not hit)
{
	_char.hp -= damage;
	hit = true;
}

// every second reset the hit timer
if(reset and duration % room_speed == 0)
	hit = false;
	
switch(spr)
{
	case spr_circle_aoe:
		image_angle += 7*dir;
	break;
	case spr_line_aoe:

		x += lengthdir_x(1,image_angle+90)*sin(duration)
		y += lengthdir_y(1,image_angle+90)*sin(duration)
	break;
	case spr_melee_aoe:
	
	break;

}
	
if(duration <= 0)
	instance_destroy();
duration -= 1;
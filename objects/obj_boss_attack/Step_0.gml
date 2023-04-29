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
		image_angle += 15*dir;
		image_xscale *= 1.0005;
		image_yscale *= 1.0005;
		
	break;
	case spr_line_aoe:
		var _strength = 4;
		x += lengthdir_x(_strength,image_angle+90)*sin(duration div 3)
		y += lengthdir_y(_strength,image_angle+90)*sin(duration div 3)
	break;
	case spr_melee_aoe:
	
	break;

}
	
if(duration <= 0)
	instance_destroy();
duration -= 1;
/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod
image_blend = c_white;
//image_speed = 1;
hit = false;
sprite_index = spr;
image_index = 1;

dir = choose(1,-1);

switch(spr)
{
	case spr_circle_aoe:
		image_xscale = choose(1,-1);
		image_yscale = choose(1,-1);
	break;
	case spr_line_aoe:
		image_speed = 1;
		duration = floor(room_speed/(image_number)*(image_number-1));
		image_yscale = choose(1,-1);
	break;
	case spr_melee_aoe:
	
		image_yscale = choose(1,-1);
	break;

}
/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod
image_blend = c_white;
image_alpha = 1;
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
		var _sound = choose(snd_circle_aoe_1);
		with(obj_particle_system)
		{
			spawn_particles(other.x,other.y,part_brown,30,other.sprite_width/2);
		}
	break;
	case spr_line_aoe:
		image_speed = 1;
		duration = floor(room_speed/(image_number)*(image_number-1));
		image_yscale = choose(1,-1);
		var _sound = choose(snd_line_aoe_1,snd_line_aoe_2);
		with(obj_particle_system)
		{
			spawn_particles(other.x,other.y,part_white,40,(other.bbox_bottom-other.bbox_top)/2);
		}
	break;
	case spr_melee_aoe:
		image_speed = 1;
		image_yscale = choose(1,-1);
		var _sound = choose(snd_melee_aoe_1);
		with(obj_particle_system)
		{
			spawn_particles(other.x,other.y,part_smoke,6,other.sprite_width/2);
		}
	break;

}


audio_play_sound(_sound,3,false);
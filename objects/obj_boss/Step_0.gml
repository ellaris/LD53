/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

var _attack_pressed = mouse_check_button_pressed(mb_left) or keyboard_check_pressed(vk_space)
	or keyboard_check_pressed(vk_enter);

if(fatigue_stunned)
	sprite_index = spr_boss_stunned;
else if( not (last_hp > hp+5) and (ability_cd < ability_max_cd -15))
	sprite_index = spr_boss_idle

if(_attack_pressed and hp_bars > 0)
{
	if(ability_cd == 0 and not fatigue_stunned)
	{
		
		sprite_index = spr_boss_attack
		ability_cd = ability_max_cd;
		fatigue += fatigue_increase;
		if(fatigue >= max_fatigue)
		{
			fatigue = max_fatigue;
			fatigue_stunned = true;
		}
		
		var _ability = ability_list[ability_current_index];
		var _xx = mouse_x, _yy = mouse_y;
		var _attack = instance_create_layer(_xx,_yy,"Attacks",obj_boss_attack_indication,_ability);
		var _time = ability_warning_time;
		if(enraged)
		{
			_time = _time * 0.5;
			_attack.damage = _ability.damage*2;
		}
		_attack.time = _time;
		_attack.sprite_index = _ability.spr;
		
		switch(ability_current_index)
		{
			case 0:
				
			break;
			
			case 1:
				//_attack.image_xscale = 4;
				//_attack.image_yscale = 4;
				var _dir = point_direction(x,y,mouse_x,mouse_y);
				_attack.image_angle = _dir;
				_attack.x = x;
				_attack.y = y;
				//_attack.x = x+lengthdir_x(_attack.sprite_width/2,_dir);
				//_attack.y = y+lengthdir_y(_attack.sprite_height/2,_dir);
			break;
			
			case 2:
				var _dir = point_direction(x,y,mouse_x,mouse_y);
				_attack.image_angle = _dir;
				_attack.x = x;
				_attack.y = y;
			break;
		}
		//_attack.damage = _ability.damage;
		
		//_attack.spr = _ability.sprite;
		
		//_attack.reset = true;
		//_attack.duration = room_speed*3; // 3s
		
		ability_current_index += 1;
		if(ability_current_index >= array_length(ability_list))
			ability_current_index = 0
	}
}

if (ability_cd > 0)
	ability_cd -= 1;
	
if(fatigue > 0)
	fatigue -= fatigue_step_loss;
else
	fatigue_stunned = false;
	
if(last_hp < hp)
	last_hp = hp;
else
	last_hp = lerp(last_hp,hp,0.035);
	
if(enraged and enrage_draw_offset > 0)
	enrage_draw_offset -= 0.2;
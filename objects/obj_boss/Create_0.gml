/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

// attacks
circle_aoe = {
	damage: 2,
	spr: spr_circle_aoe,
	duration: round(room_speed*3.5),
	reset: true,
}

line_aoe = {
	damage: 5,
	spr: spr_line_aoe,
	duration: round(room_speed*0.6),
	reset: false,
}


melee_aoe = {
	damage: 20,
	spr: spr_melee_aoe,
	duration: round(room_speed*0.3),
	reset: false,
}

max_hp = 200;
hp = max_hp;
last_hp = hp;
hp_bars = 10;
enraged = false; // 2nd stage

fatigue = 0;
fatigue_increase = 65;
max_fatigue = 100;
fatigue_step_loss = max_fatigue/room_speed/6; // 4s
fatigue_stunned = false;

take_damage = function(_damage){
	if(fatigue_stunned)
		_damage = _damage*2;
	hp -= _damage;
	if(hp <= 0)
	{
		hp_bars -= 1;
		hp = max_hp - abs(hp);
	}
	if(hp_bars == 5)
		enraged = true;
		
	var _sound = choose(snd_boss_hit_1,snd_boss_hit_2,snd_boss_hit_3);
	audio_play_sound(_sound,3,false);
}

ability_max_cd = 2*room_speed; // 2s
ability_cd = 0
ability_warning_time = 2*room_speed; // 2s
ability_list = [circle_aoe, line_aoe, melee_aoe]
ability_current_index = 0;

// debug
//fatigue_increase = 1;
//ability_max_cd = 10;

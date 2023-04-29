/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

// Inherit the parent event
event_inherited();


state_normal = function(){
	
	speed = 0;
	avoid_damage = false;
	
	//var _dir_to_center = point_direction(x,y,room_width/2,room_height/2);
	
	if(initial_quip_cd == 1)
	{
		make_quip(quips.start);	
	}
	
	// update lost hp and speak
	if(hp < last_hp-10 and hp > 0)
	{
		last_hp = hp;
		if(hp_quip_cd == 0)
		{
			hp_quip_cd = hp_quip_max_cd;
			make_quip(quips.hit);	
		}
	}
	
	if(obj_boss.fatigue_stunned and not boss_stunned)
	{
		//boss_enraged = true;
		make_quip(quips.stunned)
	}
	boss_stunned = obj_boss.fatigue_stunned;
	
	
	// end of game quips
	if(hp <= 0 and not last_quip)
	{
		last_quip = true;
		make_quip(quips.victory)
	}
	if(obj_boss.hp_bars == 0 and not last_quip)
	{
		last_quip = true;
		make_quip(quips.defeat)
	}
	if(last_quip)
		return(0);
	
	
	// make a mistake
	if(obj_boss.hp_bars != last_boss_bars)
	{
		last_boss_bars = obj_boss.hp_bars;
		make_mistake = true;
	}
	
	if(make_mistake and dodge_cd == 0)
	{
		make_mistake = false;
		make_quip(quips.mistake);
		direction = point_direction(x,y,obj_boss.x,obj_boss.y);
		state = get_state(states.dodge);
		return(0)
	}
	
	
	// move away from attacks
	//var _danger = instance_place(x,y,obj_boss_attacks);
	var _danger = collision_rectangle(bbox_left-sprite_width/2,bbox_top-sprite_height/2,
		bbox_right+sprite_width/2,bbox_bottom+sprite_height/2,obj_boss_attacks,true,true)
	if(_danger)
	{
		direction = point_direction(_danger.x,_danger.y,x,y);
		
		if(_danger.spr = spr_line_aoe)
		{
			var _dist = point_distance(x,y,_danger.x,_danger.y);
			direction = point_direction(_danger.x+lengthdir_x(_dist,_danger.image_angle),_danger.y+lengthdir_y(_dist,_danger.image_angle),x,y)
		}

		if(dodge_cd == 0 and _danger.time <= 10)
		{
			state = get_state(states.dodge);
			if(irandom(2) == 0)
				make_quip(quips.dodge);
		}
		else
			state = get_state(states.move);
		return(0);
	}
	
	//shoot
	if(attack_cd == 0)
	{
		var _tripple_chance = 6;
		// tripple shot
		if(ability_cd == 0 and irandom(_tripple_chance-1) == 0)
		{
			make_quip(quips.ability)
			ability_current_shots = ability_shots; 
			
			state = get_state(states.animation);
			animation_end_state = get_state(states.attack);
			animation_time = 2;
			ability_cd = ability_max_cd;
			attack_cd = attack_max_cd; // so it doesn't shoot at the end of the tripple shot
		}
		state = get_state(states.animation);
		animation_end_state = get_state(states.attack);
		animation_time = 2;
		attack_cd = attack_max_cd;
		// change sprite
		return(0);
	}
	
	// move to preferable position
	var _boss_hp_ratio = obj_boss.hp/obj_boss.max_hp;
	var _dir = point_direction(obj_boss.x,obj_boss.y,room_width/2,room_height/2);
	_dir += target_direction;
	var _offset = 64;
	var _xx = obj_boss.x+lengthdir_x(obj_boss.sprite_width/2+sprite_width*4,_dir), 
	_yy = obj_boss.y+lengthdir_y(obj_boss.sprite_height/2+sprite_height*4,_dir);
	var _length_offset = _offset*(_boss_hp_ratio*2-1);
	_xx += lengthdir_x(_length_offset,_dir);
	_yy += lengthdir_y(_length_offset,_dir);
	var _dist = point_distance(x,y,_xx,_yy);
	if(_dist > move_speed*2)
	{
		_dir = point_direction(x,y,_xx,_yy);
		var _xx = x+lengthdir_x(move_speed,_dir);
		var _yy = y+lengthdir_y(move_speed,_dir);
		var _danger = instance_place(_xx,_yy,obj_boss_attacks);
		if(not _danger)
		{
			direction = _dir;
			state = get_state(states.move);
			return(0);
		}
	}
	else
		target_direction = (target_spread)/2+1-irandom(target_spread+1);
	
}

state_attack = function(){
	var _xx,_yy; // offset to attack from the front of the character rather than middle
	var _dir = point_direction(x,y,obj_boss.x,obj_boss.y);
	_xx = x + lengthdir_x(sprite_width/2,_dir);
	_yy = y + lengthdir_y(sprite_height/2,_dir);
	
	if(ability_current_shots > 0)
	{
		var _offset_dir = 180-irandom(90);
		_xx += lengthdir_x(sprite_width/2,_dir+_offset_dir);
		_yy += lengthdir_y(sprite_width/2,_dir+_offset_dir);
	}
	
	var _attack = instance_create_layer(_xx,_yy,"Instances",obj_box);
	
	_attack.damage = attack_damage;
	_attack.time = 15;
	_attack.spd = attack_move_speed;
	_attack.direction = _dir;
	_attack.image_angle = _dir;
	
	animation_time = 15;
	
	state = get_state(states.animation);
	if(ability_current_shots > 0)
	{
		_attack.rotate = choose(1,0,-1);
		_attack.spd *= 1.25;
		ability_current_shots -= 1;
		animation_end_state = get_state(states.attack);	
		animation_time = 10;
	}
	if(ability_current_shots == 0)
	{
		animation_end_state = get_state(states.normal);
	}
	
	
}

state_dodge = function(){
	//var _danger = collision_rectangle(bbox_left-sprite_width/2,bbox_top-sprite_height/2,
	//	bbox_right+sprite_width/2,bbox_bottom+sprite_height/2,obj_boss_attacks,true,true);
	//if(_danger)
	//{
	//	if(_danger.time <= 10)
	//	{
	//		state = get_state[states.normal];
	//		return(0);
	//	}
	//}
	speed = 0;
	direction = point_direction(x,y,obj_boss.x,obj_boss.y);
	dodge_cd = dodge_max_cd+dodge_time;
	animation_time = dodge_time;
	avoid_damage = true;
	state = get_state(states.animation);
	animation_end_state = get_state(states.normal);
}

quip_database = [
// mistake
["mistake"],

// ability
["ability"],

// hit
["hit"],

// dodge
["dodge"],

// start
["start"],

// victory
["victory"],

// defeat
["defeat!"],

// sstunned
["stunned"],
]

take_damage = function(_damage){
	if(not avoid_damage)
		hp -= _damage;
}

state_list = [state_normal,state_animation,state_attack,state_dodge,state_move,state_tripple_attack];


attack_damage = 20;
attack_max_cd = room_speed*2; // 1s
attack_move_speed = 4;

move_speed = 3.5;
//dodge_speed = move_speed*1.5;
dodge_time = room_speed; // 1s
dodge_max_cd = room_speed *4; // 4s
avoid_damage = false;

target_spread = 80;
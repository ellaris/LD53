/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

state_normal = function(){
	
	speed = 0;
	
	// move away from attacks
	var _danger = instance_place(x,y,obj_boss_attacks);
	if(_danger)
	{
		direction = point_direction(_danger.x,_danger.y,x,y);
		state = get_state(states.move);
		return(0);
	}
	
	//shoot
	if(attack_cd == 0)
	{
		var _tripple_chance = 10;
		// tripple shot
		if(ability_cd == 0 and irandom(_tripple_chance-1) == 0)
		{
			ability_current_shots = ability_shots; 
			
			state = get_state(states.animation);
			animation_end_state = get_state(states.attack);
			animation_time = 2;
			ability_cd = ability_max_cd;
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
	var _offset = 32;
	var _xx = room_width/2, _yy = room_height/2;
	var _length_offset = _offset*(1-_boss_hp_ratio*2);
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
	
}

state_attack = function(){
	var _xx,_yy; // offset to attack from the front of the character rather than middle
	var _dir = point_direction(x,y,obj_boss.x,obj_boss.y);
	_xx = x + lengthdir_x(sprite_width/2,_dir);
	_yy = y + lengthdir_y(sprite_height/2,_dir);
	
	var _attack = instance_create_layer(_xx,_yy,"Instances",obj_letter);
	
	_attack.damage = attack_damage;
	_attack.speed = attack_move_speed;
	_attack.direction = _dir;
	_attack.image_angle = _dir;
	
	state = get_state(states.animation);
	if(ability_current_shots == 0)
	{
		animation_end_state = get_state(states.normal);
	}
	else
	{
		ability_current_shots -= 1;
		animation_end_state = get_state(states.attack);	
	}
	animation_time = 2;
}

state_animation = function(){
	if(animation_time > 0)
	{
		animation_time -= 1;
	}
	else
	{
		state = animation_end_state;
		animation_end_state = get_state(states.normal);
	}
}

state_dodge = function(){
	state = get_state(states.normal);
}

state_move = function(){
	speed = move_speed;
	state = get_state(states.normal);
}

state_tripple_attack = function(){
	state = get_state(states.normal);
}


max_hp = 100;
hp = max_hp;

move_speed = 3;
dodge_speed = move_speed*3;
dodge_time = room_speed/2; // 0.5s
dodge_max_cd = room_speed *3; // 3s
dodge_cd = 0;

attack_damage = 10;
attack_max_cd = room_speed; // 1s
attack_cd = 0; // ready
attack_move_speed = 6;

ability_damage = 10
ability_max_cd = room_speed*5; // 5s
ability_cd = 0;
ability_shots = 3;
ability_current_shots = 0;
ability_shot_cd = 5;

decrease_cd = function(){
	if(dodge_cd > 0)
		dodge_cd -= 1;
		
	if(attack_cd > 0)
		attack_cd -= 1;
		
	if(ability_cd > 0)
		ability_cd -= 1;
}

enum states {
	normal,
	animation,
	attack,
	dodge,
	move,
	tripple_attack,
}

state_list = [state_normal,state_animation,state_attack,state_dodge,state_move,state_tripple_attack];
// debug
state_desc = ["Normal","Anim","Attack","Dodge","Move","TrippleAttack"];

get_state = function(_state_index){
	return(state_list[_state_index])
}

state = get_state(states.normal);
animation_end_state = get_state(states.normal);
animation_time = 0;


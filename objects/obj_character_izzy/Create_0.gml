/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

// Inherit the parent event
event_inherited();


state_normal = function(){
	
	avoid_damage = false;
	sprite_index = spr_izzy_idle;
	
	speed = 0;
	if(x < 0 or x > room_width or y < 0 or y > room_height)
		speed = move_speed;
		
	if(last_quip)
	{
		direction = 180;
		speed = move_speed/2;
		if(x < 0)
			room_goto_previous();
			
		return(0);
	}
	
	// movement
		
	var _boss_hp_ratio = obj_boss.hp/obj_boss.max_hp;
	var _dir = point_direction(obj_boss.x,obj_boss.y,room_width/2,room_height/2);
	_dir += target_direction;
	var _offset = 64;
	var _target_x = obj_boss.x+lengthdir_x(obj_boss.sprite_width/2+abs(sprite_width)*4,_dir),
	_target_y = obj_boss.y+lengthdir_y(obj_boss.sprite_height/2+sprite_height*4,_dir);
	var _length_offset = _offset*(_boss_hp_ratio*2-1);
	_target_x += lengthdir_x(_length_offset,_dir);
	_target_y += lengthdir_y(_length_offset,_dir);
	//show_debug_message(string(_boss_hp_ratio)+"h "+string(_length_offset)+"l "+string(_dir)+"d "+string(_target_x)+" "+string(_target_y)
	//	+" "+string(abs(sprite_width))+" "+string(obj_boss.sprite_width)+" "+string(obj_boss.x))
	
	//keep to the middle and avoid outside of the map
	var _dist = point_distance(x,y,_target_x,_target_y)/point_distance(0,room_height/2,0,0);
	
	_dist = clamp(_dist,0.15,1.8);
	var _dir = point_direction(x,y,_target_x,_target_y);
	var _xx = lengthdir_x(_dist,_dir),_yy = lengthdir_y(_dist,_dir);
	var _vec = new Vector2(_xx,_yy);
	
	var _dist = 1-point_distance(x,y,obj_boss.x,obj_boss.y)/
		point_distance(x,y,_target_x,_target_x);
	
	// move away if too close to the boss
	//_dist = clamp(_dist,0.0,0.4);
	//var _dir = point_direction(obj_boss.x,obj_boss.y,_target_x,_target_y);
	//var _xx = lengthdir_x(_dist,_dir),_yy = lengthdir_y(_dist,_dir);
	//var _vec_boss = new Vector2(_xx,_yy);
	//_vec.Add(_vec_boss)
	
	with(obj_boss_attacks)
	{
		var _dist = place_meeting(x,y,obj_character)
		if(_dist == 0)
			_dist = 1.5-distance_to_object(other)/(other.sprite_width/2);
		_dist = clamp(_dist,0.1,0.9);
		var _dir = point_direction(x,y,other.x,other.y);
		if(spr = spr_line_aoe)
		{
			var _dist_l = point_distance(other.x,other.y,x,y);
			_dir = point_direction(x+lengthdir_x(_dist_l,image_angle),y+lengthdir_y(_dist_l,image_angle),other.x,other.y)
		}
		
		var _xx = lengthdir_x(_dist,_dir),_yy = lengthdir_y(_dist,_dir);
		var _vec_a = new other.Vector2(_xx,_yy);
		_vec.Add(_vec_a);	
	}
	direction = point_direction(x,y,x+_vec.x,y+_vec.y);
	
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
		var _sound = choose(snd_game_end_1);
		audio_play_sound(_sound,3,false);
	}
	if(obj_boss.hp_bars == 0 and not last_quip)
	{
		last_quip = true;
		make_quip(quips.defeat)
		var _sound = choose(snd_game_end_1);
		audio_play_sound(_sound,3,false);
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
	var _danger = collision_rectangle(x-abs(sprite_width),bbox_top-sprite_height/2,
		x+abs(sprite_width),bbox_bottom+sprite_height/2,obj_boss_attacks,true,true)
	if(_danger)
	{
		//direction = point_direction(_danger.x,_danger.y,x,y);
		
		//if(_danger.spr = spr_line_aoe)
		//{
		//	var _dist = point_distance(x,y,_danger.x,_danger.y);
		//	direction = point_direction(_danger.x+lengthdir_x(_dist,_danger.image_angle),_danger.y+lengthdir_y(_dist,_danger.image_angle),x,y)
		//}

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
		sprite_index = spr_izzy_attack;
		with(obj_particle_system)
		{
			spawn_particles(other.x,other.y,part_brown,6,32);
		}
		// change sprite
		return(0);
	}
	
	// move to preferable position
	//var _boss_hp_ratio = obj_boss.hp/obj_boss.max_hp;
	//var _dir = point_direction(obj_boss.x,obj_boss.y,room_width/2,room_height/2);
	//_dir += target_direction;
	//var _offset = 64;
	//var _xx = obj_boss.x+lengthdir_x(obj_boss.sprite_width/2+sprite_width*4,_dir), 
	//_yy = obj_boss.y+lengthdir_y(obj_boss.sprite_height/2+sprite_height*4,_dir);
	//var _length_offset = _offset*(_boss_hp_ratio*2-1);
	//_xx += lengthdir_x(_length_offset,_dir);
	//_yy += lengthdir_y(_length_offset,_dir);
	//var _dist = point_distance(x,y,_xx,_yy);
	//if(_dist > move_speed*2)
	//{
	//	_dir = point_direction(x,y,_xx,_yy);
	//	var _xx = x+lengthdir_x(move_speed,_dir);
	//	var _yy = y+lengthdir_y(move_speed,_dir);
	//	var _danger = instance_place(_xx,_yy,obj_boss_attacks);
	//	if(not _danger)
	//	{
	//		direction = _dir;
	//		state = get_state(states.move);
	//		return(0);
	//	}
	//}
	//else
	//	target_direction = (target_spread)/2+1-irandom(target_spread+1);
		
	var _dist = point_distance(x,y,_target_x,_target_y);
	if(_dist > move_speed*2)
	{
		//_dir = point_direction(x,y,_xx,_yy);
		var _xx = x+lengthdir_x(move_speed,direction);
		var _yy = y+lengthdir_y(move_speed,direction);
		var _danger = instance_place(_xx,_yy,obj_boss_attacks);
		if(not _danger)
		{
			//direction = _dir;
			state = get_state(states.move);
			return(0);
		}
	}
	else
	{
		target_direction = (target_spread)/2+1-irandom(target_spread+1);
		direction = point_direction(x,y,obj_boss.x,obj_boss.y);
		show_debug_message(string(_target_x)+" "+string(_target_y)+" "+string(target_direction)+" target")
	}
	
}

state_attack = function(){
	var _xx,_yy; // offset to attack from the front of the character rather than middle
	var _dir = point_direction(x,y,obj_boss.x,obj_boss.y);
	_xx = x + lengthdir_x(abs(sprite_width)/2,_dir);
	_yy = y + lengthdir_y(sprite_height/2,_dir);
	
	if(ability_current_shots > 0)
	{
		var _offset_dir = 180-irandom(90);
		_xx += lengthdir_x(abs(sprite_width)/2,_dir+_offset_dir);
		_yy += lengthdir_y(abs(sprite_width)/2,_dir+_offset_dir);
	}
	
	var _sound = choose(snd_box_1,snd_box_2);
	audio_play_sound(_sound,3,false);
	
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
	sprite_index = spr_izzy_dodge;
	dodge_cd = dodge_max_cd+dodge_time;
	animation_time = dodge_time;
	avoid_damage = true;
	state = get_state(states.animation);
	animation_end_state = get_state(states.normal);
	
}

quip_database = [
// mistake
["No, my package slipped out", "Let me take a break", "Time out, I need to catch my breath",
	"Let me give you a chance"],

// ability
["Eat my package!", "This should fill you up", "Package barrage!", "You shall get the pacakge"],

// hit
["Not the package", "Oi, stop that", "Straight back", "Too heavy", "I'll be late"],

// dodge
["I will block this", "Let me come inside", "No touching!", "Cardboard VPN"],

// start
["Late night stift, let's gooo!", "Those packages won't deliver themselves", "Time to package it up",
	"Oh lord, deliver me to freedom", "I've got a good pacakge, and I'm not afraid to use it", 
	"Where is the bubble wrap?! I was promissed bubble wrap!"],

// victory
["Now I have to get new pacakges to play with", "You broke my favourite package!", "Delivery time is over, I'm out!"],

// defeat
["Lunch Break! Finally something good", "It wasn't so hard, was it?", "You're full already? That was fast"],

// stunned
["Chance", "Yes, double damage", "So you also get tired", "Take a break, I don't mind","O, he stopped moving"],
]

take_damage = function(_damage){
	if(not avoid_damage)
	{
		hp -= _damage;
		sprite_index = spr_izzy_hit;
		
		var _sound = choose(snd_character_hit_1,snd_character_hit_2);
		audio_play_sound(_sound,3,false);
		
		with(obj_particle_system)
		{
			spawn_particles(other.x,other.y,part_blue,8,other.sprite_width/2);
		}
	}
	else
	{
		var _sound = choose(snd_print_1);
		audio_play_sound(_sound,3,false);	
	}
	
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
/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

state_normal = function(){
	
	speed = 0;
	
	//var _dir_to_center = point_direction(x,y,room_width/2,room_height/2);
	
	// update lost hp and speak
	if(hp < last_hp-10)
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

		if(dodge_cd == 0)
		{
			state = get_state(states.dodge);
			if(irandom(5) == 0)
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
	var _xx = room_width/2, _yy = room_height/2;
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
	
	var _attack = instance_create_layer(_xx,_yy,"Instances",obj_letter);
	
	_attack.damage = attack_damage;
	_attack.speed = attack_move_speed;
	_attack.direction = _dir;
	_attack.image_angle = _dir;
	
	
	state = get_state(states.animation);
	if(ability_current_shots > 0)
	{
		_attack.rotate = choose(1,-1);
		_attack.speed *= 1.5;
		ability_current_shots -= 1;
		animation_end_state = get_state(states.attack);	
	}
	if(ability_current_shots == 0)
	{
		animation_end_state = get_state(states.normal);
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
	speed = dodge_speed
	dodge_cd = dodge_max_cd;
	animation_time = dodge_time
	state = get_state(states.animation);
	animation_end_state = get_state(states.normal);
}

state_move = function(){
	speed = move_speed;
	state = get_state(states.normal);
}

state_tripple_attack = function(){
	state = get_state(states.normal);
}

make_quip = function(_type){
	var _quip = "quip ";
	var _quip_array = quip_database[_type];
	_quip = _quip_array[irandom(array_length(_quip_array)-1)];
	var _quip_box = instance_create_layer(x,bbox_top,"Quips",obj_quip);
	_quip_box.description = + _quip_box.description +_quip;
	show_debug_message(string(_type)+_quip);
}

enum quips {
	mistake,
	ability,
	hit,
	dodge,
	start,
	victory, // player
	defeat, // player
	stunned, // boss
}

quip_database = [
// mistake
["Mom! I can't right now, I'm playing!", "*brr brr* *click* hello?, I can't talk right now ...",
	"Kittens! Get off my keyboard!", "Noo! Lagggg!", "Need new mouse batteries", "Damn, I miss clicked",
	"Well, there goes this run", "Uf, I hope I can come back from this"],

// ability
["Letter delivery", "Christams cards", "Birthiday cards", "Death chain", "Hate mail", "Scam mail"],

// hit
["Aw, that hurt.", "How did that hit?", "These hitboxes are crap!", "I doged it, I doged it!",
	"No no no", "Ah, get away"],

// dodge
["That was close", "Not this time", "Can't touch this", "Easy", "Not even close", "Smoth",
	"I've got this"],

// start
["Tutorial boss, let's gooo", "I'll make it fast", "Let's box it UP", "Delivery time", 
	"I only got 5 minutes, so come on", "Let's see what it's all about"],

// victory
["This game sucks", "This boss is overpowered", "*scof* Yea, right", "How am I supposed to beat this?!"],

// defeat
["Ha ha, eat paper!", "That was easy", "Easy enemy!", "I want a challenge"],

// enraged
["Double damage, nice", "It's time to go", "All out now", "Eat this", "Boss's stunned, nice",
	"Ha ha, he got tired", "Unleash hell!"],
]


max_hp = 100;
hp = max_hp;
last_hp = hp;
hp_quip_max_cd = room_speed*2;
hp_quip_cd = 0;

move_speed = 4;
dodge_speed = move_speed*1.5;
dodge_time = room_speed/2; // 0.333s
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

target_direction = 0;
target_spread = 120;

make_mistake = false;
last_boss_bars = obj_boss.hp_bars;
boss_stunned = false;

last_quip = false;

decrease_cd = function(){
	if(dodge_cd > 0)
		dodge_cd -= 1;
		
	if(attack_cd > 0)
		attack_cd -= 1;
		
	if(ability_cd > 0)
		ability_cd -= 1;
		
	if(hp_quip_cd > 0)
		hp_quip_cd -= 1;
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


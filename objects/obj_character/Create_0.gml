/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

Vector2 = function(_x, _y) constructor
{
	x = _x;
	y = _y;
	
	static Add = function(_vec2)
	{
		x += _vec2.x;
		y += _vec2.y;
	}
}

state_normal = function(){
	
	sprite_index = spr_norman_idle;
	
	speed = 0;
	if(x < 0 or x > room_width or y < 0 or y > room_height)
	{
		speed = move_speed;
		direction = point_direction(x,y,room_width/2,room_height/2);
	}
		
	if(last_quip)
	{
		direction = 180;
		speed = move_speed;
		if(x < 0)
			room_goto_previous();
			
		return(0);
	}
	
	// movement
	
	var _boss_hp_ratio = obj_boss.hp/obj_boss.max_hp;
	var _dir = point_direction(obj_boss.x,obj_boss.y,room_width/2,room_height/2);
	_dir += target_direction;
	var _offset = 128;
	var _target_x = room_width/2
	var _target_y = room_height/2;
	var _length_offset = _offset*(_boss_hp_ratio*2-1);
	_target_x += lengthdir_x(_length_offset,_dir);
	_target_y += lengthdir_y(_length_offset,_dir);
	
	// keep to the middle and avoid outside of the map
	var _dist = point_distance(x,y,_target_x,_target_y)/point_distance(0,room_height/2,0,0);
	_dist = clamp(_dist,0.1,1);
	var _dir = point_direction(x,y,_target_x,_target_y);
	var _xx = lengthdir_x(_dist,_dir),_yy = lengthdir_y(_dist,_dir);
	var _vec = new Vector2(_xx,_yy);
	
	var _dist = 1-point_distance(x,y,obj_boss.x,obj_boss.y)/
		point_distance(x,y,_target_x,_target_x);
	
	//// move away if too close to the boss
	//_dist = clamp(_dist,0.0,0.4);
	//var _dir = point_direction(obj_boss.x,obj_boss.y,_target_x,_target_y);
	//var _xx = lengthdir_x(_dist,_dir),_yy = lengthdir_y(_dist,_dir);
	//var _vec_boss = new Vector2(_xx,_yy);
	//_vec.Add(_vec_boss)
	
	with(obj_boss_attacks)
	{
		var _dist = place_meeting(x,y,obj_character)
		if(_dist == 0)
			_dist = 0.9-point_distance(x,y,other.x,other.y)/(other.sprite_width);
		_dist = clamp(_dist,0.3,1);
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
	
	var _stay_put = (abs(_vec.x)+abs(_vec.y)) <= 0.15
	show_debug_message((abs(_vec.x)+abs(_vec.y)))
	direction = point_direction(x,y,x+_vec.x,y+_vec.y);
	//speed = move_speed/2;
	
	//return(0)
	
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
		return(0)
	}
	if(obj_boss.hp_bars == 0 and not last_quip)
	{
		last_quip = true;
		make_quip(quips.defeat)
		return(0)
	}
	
	
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

		if(dodge_cd == 0)
		{
			direction = point_direction
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
		sprite_index = spr_norman_attack
		// change sprite
		return(0);
	}
	
	// move to preferable position
	
	var _dist = point_distance(x,y,_target_x,_target_y);
	if(_dist > move_speed*2)
	{
		//_dir = point_direction(x,y,_xx,_yy);
		var _xx = x+lengthdir_x(move_speed,direction);
		var _yy = y+lengthdir_y(move_speed,direction);
		var _danger = instance_place(_xx,_yy,obj_boss_attacks);
		if(not _danger and not _stay_put)
		{
			//direction = _dir;
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
	_xx = x + lengthdir_x(abs(sprite_width)/2,_dir);
	_yy = y + lengthdir_y(sprite_height/2,_dir);
	
	var _attack = instance_create_layer(_xx,_yy,"Attacks",obj_letter);
	
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
	sprite_index = spr_norman_dodge
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
	//show_debug_message(string(_type)+_quip);
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
	"Kittens! Get off my keyboard!", "Noooo! Laggggg!", "Oh, need new mouse batteries", "Damn, I miss clicked",
	"Well, there goes this run", "Uf, I hope I can come back from this"],

// ability
["Letter delivery", "Christams cards", "Birthiday cards", "Death chain", "Hate mail", "Scam mail"],

// hit
["Aw, that hurt.", "How did that hit?", "These hitboxes are crap!", "What?! I doged, I doged it!",
	"No no no", "Ah, get away"],

// dodge
["That was close", "Not this time", "Can't touch this", "Easy", "Not even close", "Smooth move",
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
hp_quip_max_cd = room_speed*4;
hp_quip_cd = 0;

move_speed = 4;
dodge_speed = move_speed*1.5;
dodge_time = room_speed/2; // 0.333s
dodge_max_cd = room_speed *3; // 3s
dodge_cd = 0;

attack_damage = 10;
attack_max_cd = room_speed; // 1s
attack_cd = room_speed*4; // ready
attack_move_speed = 6;

ability_max_cd = room_speed*5; // 5s
ability_cd = 0;
ability_shots = 3;
ability_current_shots = 0;
ability_shot_cd = 5;

target_direction = 0;
target_spread = 160;

make_mistake = false;
last_boss_bars = obj_boss.hp_bars;
boss_stunned = false;

last_quip = false;
initial_quip_cd = room_speed*2;

decrease_cd = function(){
	if(dodge_cd > 0)
		dodge_cd -= 1;
		
	if(attack_cd > 0)
		attack_cd -= 1;
		
	if(ability_cd > 0)
		ability_cd -= 1;
		
	if(hp_quip_cd > 0)
		hp_quip_cd -= 1;
		
	if(initial_quip_cd > 0)
		initial_quip_cd -= 1;
		
	hp = max(hp,0);
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
//state_desc = ["Normal","Anim","Attack","Dodge","Move","TrippleAttack"];

get_state = function(_state_index){
	return(state_list[_state_index])
}

take_damage = function(_damage){
	hp -= _damage;	
	sprite_index = spr_norman_hit;
}

state = get_state(states.normal);
animation_end_state = get_state(states.normal);
animation_time = 0;


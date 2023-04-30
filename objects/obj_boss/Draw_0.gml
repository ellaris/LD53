/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

draw_self();

// hp bar
var _offset = 32;
var _bar_width = room_width-(_offset*2);
var _bar_height = 32;
var _xx = _offset;
var _yy = _offset;
var _hp_ratio = hp/max_hp;

draw_set_color(c_black);
draw_rectangle(_xx,_yy,_xx+_bar_width,_yy+_bar_height,false);

if(enraged)
	draw_set_color(c_red);
else
	draw_set_color(c_maroon);
// +-1 to have an outline of the previous rectangle
draw_rectangle(_xx+1,_yy+1,_xx+_bar_width*_hp_ratio-1,_yy+_bar_height-1,false);

draw_set_color(c_purple)
draw_rectangle(_xx+1+_bar_width*_hp_ratio,_yy+1,_xx+_bar_width*last_hp/max_hp-1,_yy+_bar_height-1,false);


// draw text hp and bar number
if(hp_bars > 0)
{
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(_xx+_bar_width/2,_yy+_bar_height/2,string(hp)+"/"+string(max_hp))
	if(hp_bars > 1)
	{
		draw_text(_xx+_bar_width-_offset,_yy+_bar_height/2,"X"+string(hp_bars))	
	}
}

// draw fatigue
_yy += _offset*2;
var _fatigue_ratio = fatigue/max_fatigue;
draw_set_color(c_black);
draw_rectangle(_xx,_yy,_xx+_bar_width,_yy+_bar_height,false);

if(fatigue_stunned)
	draw_set_color(c_orange)
else
	draw_set_color(c_yellow);
// +-1 to have an outline of the previous rectangle
draw_rectangle(_xx+1,_yy+1,_xx+_bar_width*_fatigue_ratio-1,_yy+_bar_height-1,false);

draw_set_color(c_white);

// draw abilities boxes
_yy += _offset*3;
_xx = 0+_offset;

var _box_size = 32;
for(var i =0; i < array_length(ability_list); i++)
{

	draw_set_color(c_dkgray);
		
	draw_rectangle(_xx,_yy,_xx+_box_size,_yy+_box_size,false);
	if(i == ability_current_index)
	{
		draw_set_color(c_aqua);
		draw_rectangle(_xx,_yy,_xx+_box_size,_yy+_box_size,true);
	}
	_ability = ability_list[i];
	if(ability_cd > 0)
	{
		//draw_set_color(c_maroon)
		//gpu_set_blendmode(bm_subtract)
		gpu_set_colorwriteenable(true,false,false,false);
	}
	
	draw_sprite_stretched(_ability.spr,0,_xx,_yy,_box_size,_box_size);
	gpu_set_colorwriteenable(true,true,true,true);
	//gpu_set_blendmode(bm_normal)
	_xx += _box_size+_offset;
}
draw_set_color(c_white);
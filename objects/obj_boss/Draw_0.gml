/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

draw_self();

// hp bar
var _offset = 16;
var _bar_width = room_width-(_offset*2);
var _bar_height = 16;
var _xx = _offset;
var _yy = _offset;
var _hp_ratio = hp/max_hp;

draw_set_color(c_black);
draw_rectangle(_xx,_yy,_xx+_bar_width,_yy+_bar_height,false);

draw_set_color(c_red);
// +-1 to have an outline of the previous rectangle
draw_rectangle(_xx+1,_yy+1,_xx+_bar_width*_hp_ratio-1,_yy+_bar_height-1,false);


// draw text hp and bar number
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_xx+_bar_width/2,_yy+_bar_height/2,string(hp)+"/"+string(max_hp))
if(hp_bars > 1)
{
	draw_text(_xx+_bar_width-_offset,_yy+_bar_height/2,"X"+string(hp_bars))	
}

// draw fatigue
_yy += _offset*2
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
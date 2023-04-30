/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

draw_self();

// draw_hp bar
draw_set_color(c_black);
var _hp_ratio = hp/max_hp;
var _bar_width = sprite_width;
var _bar_height = 8;
var _xx = x-_bar_width/2;
var _yy = y-sprite_height/2-_bar_height;

draw_rectangle(_xx,_yy,_xx+_bar_width,_yy+_bar_height,true);
draw_set_color(c_green);
draw_rectangle(_xx,_yy,_xx+_bar_width*_hp_ratio,_yy+_bar_height,false);

draw_set_color(c_white);

//draw_set_color(c_green);

//draw_line_width(x,y,x+lengthdir_x(sprite_width/2,direction),y+lengthdir_y(sprite_height/2,direction),3);
//draw_point(_target_x,_target_y)
//draw_text(x,y,"Acd:"+string(attack_cd)+
//"\nhp:"+string(hp)+"/"+string(max_hp))
/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var _line_height = 14;
var _line_width = 256;

var _str_width = string_width_ext(description,_line_height,_line_width)+8*2;
var _str_height = string_height_ext(description,_line_height,_line_width)+8*2;
draw_sprite_stretched(sprite_index,image_index,x-_str_width/2,y-_str_height,_str_width,_str_height);
draw_set_color(c_grey);
draw_text_ext(x-_str_width/2+8,y-_str_height+8,description,_line_height,_line_width);
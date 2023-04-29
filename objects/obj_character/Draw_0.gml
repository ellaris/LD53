/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

draw_self();

draw_text(x,y,"S:"+state_desc[array_get_index(state_list,state)]+
"\nA:"+string(animation_time)+
"\nAcd:"+string(attack_cd)+
"\nhp:"+string(hp)+"/"+string(max_hp))
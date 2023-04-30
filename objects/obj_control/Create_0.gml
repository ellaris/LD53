/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod

left_bind_1 = ord("A");
left_bind_2 = vk_left;

right_bind_1 = ord("D");
right_bind_2 = vk_right;

confirm_bind_1 = vk_space;
confirm_bind_2 = vk_enter;

selection = 0;

character_list = [obj_character_izzy,obj_character]
character_names = ["Izzy","Norman"]

animation_value = 270;
animation_angle = 270;
animation_angle_change = 55;

background_track = noone;
background_track = audio_play_sound(snd_background_track_2,4,true);
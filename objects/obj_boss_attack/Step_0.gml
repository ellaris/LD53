/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod
var _char = instance_place(x,y,obj_character);
if(_char and not hit)
{
	_char.hp -= damage;
	hit = true;
}

// every second reset the hit timer
if(reset and duration % room_speed == 0)
	hit = false;
	
if(duration <= 0)
	instance_destroy();
duration -= 1;
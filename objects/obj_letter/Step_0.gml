/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod
var _boss = instance_place(x,y,obj_boss);

image_angle += rotate*5;
if(_boss)
{
	_boss.take_damage(damage);
	instance_destroy();
}
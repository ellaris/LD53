/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod
var _boss = instance_place(x,y,obj_boss);

image_angle += rotate*5;
if(_boss)
{
	_boss.take_damage(damage);
	with(obj_particle_system)
	{
		spawn_particles(other.x-other.sprite_width/2,other.y,part_white,5,8);
		spawn_particles(other.x+other.sprite_width/2,other.y,part_red,4,15);
	}
	instance_destroy();
}
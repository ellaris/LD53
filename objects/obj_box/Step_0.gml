/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod
var _boss = instance_place(x,y,obj_boss);
if(time > 0)
	time -= 1;
else
	speed = spd;

image_angle += rotate*5;
if(_boss)
{
	_boss.take_damage(damage);
	
	with(obj_particle_system)
	{
		spawn_particles(other.x,other.y,part_brown,4,20);
		spawn_particles(other.x+other.sprite_width/2,other.y,part_red,4,15);
	}
	instance_destroy();
}
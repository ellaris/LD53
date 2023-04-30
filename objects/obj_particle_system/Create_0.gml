/// @description Wstaw opis w tym miejscu
// W tym edytorze możesz zapisać swój kod


part_system = part_system_create();
/*
Particles
small several blue move left
	character hit
	
small several white left
	character letter attack
	boss letter attack
	letter destroy
	select norman?
	
small several brown left
	character box attack
	boss box attack
	box destroy
	select izzy?
	
small several red right
	boss hit
	
smoke
	boss melee attack
	boss box attack
*/

part_blue = part_type_create();
part_type_shape(part_blue,pt_shape_pixel);
part_type_size(part_blue,2,3,0,0);
part_type_speed(part_blue,1.2,1.8,-0.02,0);
part_type_direction(part_blue,120,210,0,0.2);
part_type_color1(part_blue,c_blue);

part_white = part_type_create();
part_type_shape(part_white,pt_shape_pixel)
part_type_size(part_white,2,3,-0.005,0)
part_type_speed(part_white,1.2,1.8,-0.02,0);
part_type_direction(part_white,120,210,0,0.2);
part_type_color1(part_white,c_white);
part_type_life(part_white,room_speed/2,room_speed*2);

part_brown = part_type_create();
part_type_shape(part_brown,pt_shape_pixel)
part_type_size(part_brown,3,5,-0.02,0)
part_type_speed(part_brown,1.0,1.4,-0.03,0);
part_type_direction(part_brown,120,210,0,0.2);
part_type_color1(part_brown,c_orange);
part_type_life(part_brown,room_speed/2,room_speed*2);

part_red = part_type_create();
part_type_shape(part_red,pt_shape_pixel)
part_type_size(part_red,4,7,0,0.02)
part_type_speed(part_red,1.2,1.6,-0.03,0);
part_type_direction(part_red,-60,60,0,0.2);
part_type_color1(part_red,c_red);
part_type_life(part_red,room_speed/2,room_speed*2);

part_smoke = part_type_create();
part_type_shape(part_smoke,pt_shape_smoke)
part_type_size(part_smoke,2,3,0,0)
//part_type_speed(part_smoke,0.1,0.15,-0.01,0);
//part_type_direction(part_smoke,0,360,0,0)
part_type_color1(part_smoke,c_grey);
part_type_life(part_smoke,room_speed/2,room_speed/2);

function spawn_particles(_x,_y,_part_type,_number,_radious){
	var i = _number;
	while(i > 0)
	{
		var _dir = irandom(360-1);
		var _dist = irandom(_radious);
		var _xx = _x+lengthdir_x(_dist,_dir);
		var _yy = _y+lengthdir_y(_dist,_dir);
		part_particles_create(part_system,_xx,_yy,_part_type,1);
		i--
	}
	
}
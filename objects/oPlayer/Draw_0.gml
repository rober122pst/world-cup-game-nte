draw_self();

if(stateShoot == chutando) {
	draw_healthbar(x-16,y-36,x+16,y-32,(forca/maxForca)*100,c_black,c_red,c_green,0,1,1);	
}
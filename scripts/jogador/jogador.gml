// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
function jogador_iniciar(){
	move = 0;
	movespeed = 8;
	hsp = 0;
	hlast = 1;
	limite_laser = 4;
	bola_fixada = 0;
}

function jogador_padrao(){
	/// colisao horizontal
	if (place_meeting(x+hsp,y,obj_solido))
	{
	    while(!place_meeting(x+sign(hsp),y,obj_solido))
	    {
	        x += sign(hsp);
	    }
	    hsp = 0;
	}
	
	x += hsp;
	
	/// velocidade horizontal
	hsp = move * (movespeed + (movespeed*global.tecla_correr));
	
	/// obter valor das teclas
	move = (global.tecla_direita - global.tecla_esquerda)
	
	// memorizar a ultima tecla pressionada
	if !(move = 0) {
		hlast = move;
	}
	
	// não deixar vazar da tela
	x = min(x,room_width-(sprite_width/2));       
	x = max(x,(sprite_width/2));
	
	if (instance_number(obj_bola) < 1) {
		jogo_perder_vida();
		instance_destroy();
	}
	
	if (global.poder_ativado[PODER.GIGA]) {
		if (image_xscale<2) {
			image_xscale +=.2
		}
	}
	
	if (global.poder_ativado[PODER.LASER]) {
		image_blend = c_red;
		if (global.tecla_atirar) && (instance_number(obj_laser)<limite_laser){
			instance_create_depth(x-(sprite_width/2),y,-1,obj_laser)
			instance_create_depth(x+(sprite_width/2),y,-1,obj_laser)
		} 
	} else {
		image_blend = c_white;
		}
}
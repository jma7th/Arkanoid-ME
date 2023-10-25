// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
function bola_iniciar(){
	
	vel_inicial = 4;
	vel = vel_inicial;
	fixar = 0;
	acc = 0;
	acc_max = 4;
	acc_add = 1;
	vel_max = 16;
	x_prev = -1;
}

function bola_padrao(){
	
	// ao passar de fase
	if (global.fase_concluida) {
		visible = 0;
		hspeed = 0;
		vspeed = 0;
	}
	
	// não deixar vazar da tela
	
	x = min(x,room_width-(sprite_width/2));       
	x = max(x,(sprite_width/2));
	y = max(y,0);
	
	// refletir nos cantos
	if (x = sprite_width/2) or (x=room_width-(sprite_width/2)) {
		hspeed *=-1;
		}
	if (y = 0) {
		vspeed *=-1;
	}
	
	// destruir se caso caia pra fora da tela
	if (y>room_height) {
		instance_destroy();
	}

	
	if instance_exists(obj_jogador) {
		if fixar = 1 {
			if (x_prev = -1) {
				x_prev = distance_to_point(obj_jogador.x,y);
				if obj_jogador.x > x {x_prev*=-1}
			}
			x = (obj_jogador.x) + x_prev;
			y = (obj_jogador.y) - 32
			if (global.tecla_atirar){
				fixar = 0;
				x_prev = -1;
				obj_jogador.bola_fixada = 0;
				hspeed = obj_jogador.hlast * vel;
				vspeed = vel*-1;
			}
		}
	}
	
	if (acc = acc_max) {
		acc = 0;
		vel += acc_add;
		hspeed = vel * sign(hspeed);
		vspeed = vel * sign(vspeed);
	}
	hspeed = clamp(hspeed,(vel_max*-1),vel_max)
	vspeed = clamp(vspeed,(vel_max*-1),vel_max)
	
	if (global.poder_ativado[PODER.LENTO]) {
		vel = vel_inicial;
		hspeed = vel*sign(hspeed);
		vspeed = vel*sign(vspeed);
		global.poder_ativado[PODER.LENTO] = 0;
	}
	
	if (global.poder_ativado[PODER.FOGO]) {
		image_blend = c_red;
	} else {
		image_blend = c_white;
	}
	
}

function bola_colisao() {
	if global.poder_ativado[PODER.FOGO] = 0 {
		move_bounce_all(true);
		acc += 1;
		}
}

function bola_colisao_solido() {
	move_bounce_all(true);
	acc += 1;
}

function bola_colisao_jogador(){
	
	if (global.poder_ativado[PODER.IMA]) && instance_exists(obj_jogador) && (obj_jogador.bola_fixada = 0) {		
		fixar = 1;
		obj_jogador.bola_fixada = 1;
		hspeed = 0;
		vspeed = 0;
	} else {
		//if vspeed > 0 {
			vspeed =-vel
			if (obj_jogador.x>x) {
				hspeed = -vel; 
			}
			if (obj_jogador.x<x) {
				hspeed = vel; 
			}
		//}
	}
}
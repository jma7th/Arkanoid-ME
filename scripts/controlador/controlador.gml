// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
function jogo_iniciar(){
enum ESTADO {
	INATIVO,
	JOGAR,
	PAUSA
	}
	
enum CENARIO {
	INICIALIZAR,
	TITULO,
	FASE,
	}
	
enum PODER {
	IMA,
	LASER,
	MULTI,
	FOGO,
	GIGA,
	LENTO,
	TODOS
}

global.estado_atual = ESTADO.INATIVO;
global.cenario_atual = CENARIO.TITULO;

global.vidas = 3;
global.pontos = 0;

global.poder_ativado[PODER.TODOS] = 0;

global.timer_passar_fase = 180;
}

function jogo_teclas(){
	global.tecla_esquerda = keyboard_check(vk_left);
	global.tecla_direita = keyboard_check(vk_right);
    global.tecla_pausar = keyboard_check_pressed(vk_space);
	global.tecla_atirar = keyboard_check_pressed(vk_shift);
	global.tecla_correr = keyboard_check(vk_lcontrol);
}

function jogo_padrao(){
	
	// obter valor das teclas
	jogo_teclas();
	// atualizar o cenario de acordo com a room
	jogo_buscar_cenario();
	// realizar ações de acordo com o estado atual
	jogo_estado();
	
	if (global.tecla_pausar) {
		jogo_pausar();		
	}
	
	// não permitir fogo e laser ao mesmo tempo para balancear o jogo
	//if global.poder_ativado[PODER.FOGO] = 1 {
//		global.poder_ativado[PODER.LASER] = 0;
//	}
	
	//if global.poder_ativado[PODER.LASER] = 1 {
	//	global.poder_ativado[PODER.FOGO] = 0;
	//}
	
	if (global.poder_ativado[PODER.MULTI]) {
		var _bola =	instance_create_depth(obj_bola.x,obj_bola.y,-1,obj_bola);
		_bola.hspeed = obj_bola.hspeed;
		_bola.vspeed = obj_bola.vel*-1;
		var _bola_2 = instance_create_depth(obj_bola.x,obj_bola.y,-1,obj_bola);
		_bola_2.hspeed = obj_bola.hspeed;
		_bola_2.vspeed = obj_bola.vel*-1;
		global.poder_ativado[PODER.MULTI] = 0;
	}
	
}

function jogo_estado(){
	switch (global.estado_atual) {
		case ESTADO.INATIVO:
			if global.cenario_atual = CENARIO.INICIALIZAR {
				room_goto(rm_titulo);
			}
			break;
		case ESTADO.JOGAR:
			if !(instance_exists(obj_jogador)) && (global.vidas >= 0){
				jogo_iniciar_fase();
			}
			if (instance_number(obj_bloco) < 1) {
				jogo_passar_fase()
				/*if (alarm[0]>-1) {
					
					alarm[0] = global.timer_passar_fase;
				}*/
			}
		default:
			break;
	}
}

function jogo_buscar_cenario(){
	switch (room) {
		case rm_inicializar:
			global.cenario_atual = CENARIO.INICIALIZAR;
			break;
		case rm_titulo:
			global.cenario_atual = CENARIO.TITULO;
			global.estado_atual = ESTADO.INATIVO;
			global.vidas = 3;
			global.pontos = 0;
			break;
		default:
			global.cenario_atual = CENARIO.FASE;
			break;
	}
}

function jogo_pausar(){
	switch (global.estado_atual) {
		case ESTADO.INATIVO:
			room_goto(rm_fase_1);
			global.estado_atual = ESTADO.JOGAR;
			break;
		case ESTADO.PAUSA:
			global.estado_atual = ESTADO.JOGAR;
			instance_activate_all();
			break;
		case ESTADO.JOGAR:
			global.estado_atual = ESTADO.PAUSA;
			
			instance_deactivate_object(obj_jogador);
			instance_deactivate_object(obj_bola);
			
			if (global.vidas < 0) {
				room_goto(rm_titulo);
			}
			break;
	}
}

function jogo_iniciar_fase(){
	var _rw = room_width;
	var _rh = room_height;
	instance_create_depth(_rw/2,_rh-32,-1,obj_jogador)
	var _bola = instance_create_depth(_rw/2,_rh-64,-1,obj_bola);
	_bola.fixar = 1;
}

function jogo_perder_vida(){
	//play_audio
	global.vidas -=1;
	for (var _i = 0; _i < PODER.TODOS; _i++) {
		global.poder_ativado[_i] = 0;
	}
}

function jogo_passar_fase(){
	room_goto_next();
}

function jogo_desenhar(){
	switch (global.cenario_atual) {
		case CENARIO.TITULO:
			desenhar_titulo();
			desenhar_debug();
			break;
		case CENARIO.FASE:
			desenhar_gui();
			desenhar_debug();
			break;
		default:
			break;
	}
	draw_set_font(fnt_padrao);
	draw_set_color(c_white);
	
}

function desenhar_debug(){
	draw_set_font(fnt_padrao);
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	
	switch (global.estado_atual) {
		case ESTADO.INATIVO:
			draw_text(16,16,global.estado_atual)
			draw_text(16,32,global.cenario_atual)
			break;
	}
}

function desenhar_gui(){
	var _sw = window_get_width();
	var _sh = window_get_height();
	draw_set_font(fnt_padrao);
	draw_set_color(c_white);
	
	
	switch (global.estado_atual) {
		case ESTADO.JOGAR:
			draw_set_halign(fa_left);
			draw_text(32,32,"Pontos: " + string(global.pontos))
			draw_text(32,48,"Vidas: " + string(global.vidas))
			if (global.vidas < 0) {
				draw_set_halign(fa_center);
				draw_text((_sw/2),(_sh/2),"GAME OVER")	
				}
			break;
		case ESTADO.PAUSA:
			draw_set_halign(fa_center);
			draw_text((_sw/2),(_sh/2),"PAUSADO")
			break;
	}
}

function desenhar_titulo(){
	var _sw = window_get_width();
	var _sh = window_get_height();
	draw_set_font(fnt_padrao);
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_sprite(spr_logo,-1,(_sw/2),(_sh/2));
	draw_text((_sw/2),((_sh/4)*3),"Aperte BARRA DE ESPAÇO para iniciar");
	draw_set_halign(fa_left)
    draw_text((_sw/12),((_sh/8)*7),"Controles:\nSetas direcionais para movimentar.\nShift Esquerdo para atirar.\nCtrl para correr.")
}
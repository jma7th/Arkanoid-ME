// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
function poder_criar(){
	poder = 0;
	visible = 0;
}

function poder_padrao(){
	if (y>room_height) {
		instance_destroy();
	}
	if !(place_meeting(x,y,obj_bloco)) && (visible = 0) {
		visible = 1;
		vspeed = 2;
	}
}

function poder_jogador() {
	
	global.poder_ativado[poder] = 1;
	global.pontos += 100;
	instance_destroy();
}
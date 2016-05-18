package ar.edu.unq.epers.aterrizar.domain


class Like {
	
//	Perfil perfil
	String nickname
	
	new(Perfil p){
		nickname = p.nickname
	}
	
	def equals(Perfil p){
		nickname.equals(p.nickname)
	}
}
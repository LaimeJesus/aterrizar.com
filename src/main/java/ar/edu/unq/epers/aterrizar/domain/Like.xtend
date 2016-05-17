package ar.edu.unq.epers.aterrizar.domain


class Like {
	
//	Perfil perfil
	String username
	
	new(Perfil p){
		username = p.username
	}
	
	def equals(Perfil p){
		username.equals(p.username)
	}
}
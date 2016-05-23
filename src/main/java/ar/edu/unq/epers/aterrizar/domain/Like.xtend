package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Like {
	
//	Perfil perfil
	int idLike
	String nickname
	
	new(Perfil p){
		nickname = p.nickname
	}
	
	def equals(Perfil p){
		nickname.equals(p.nickname)
	}
}
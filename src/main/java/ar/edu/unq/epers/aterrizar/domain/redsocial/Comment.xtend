package ar.edu.unq.epers.aterrizar.domain.redsocial

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Comment {
	
	LikeAdmin likesAdmin
	Visibility visibility
	String comment

	new (String msg){
		visibility = new Private()
		likesAdmin = new LikeAdmin()
		comment = msg
	}
	def void meGusta(Perfil p){
		likesAdmin.agregarMeGusta(p)
	}
	def void noMeGusta(Perfil p){
		likesAdmin.agregarNoMeGusta(p)
	}
	def puedeVer(Perfil preguntado, Perfil preguntando){
		visibility.puedeVer(preguntado, preguntando)
	}
}

package ar.edu.unq.epers.aterrizar.domain.redsocial

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.redsocial.LikeAdmin
import ar.edu.unq.epers.aterrizar.domain.redsocial.visibility.Visibility

@Accessors
class Comment {

	String id
	LikeAdmin likesAdmin
	Visibility visibility
	String comment

	new() {
	}

	new(String actualId, String msg) {
		id = actualId
		visibility = Visibility.PRIVATE
		likesAdmin = new LikeAdmin()
		comment = msg
	}

	def void meGusta(Perfil p) {
		likesAdmin.agregarMeGusta(p)
	}

	def void noMeGusta(Perfil p) {
		likesAdmin.agregarNoMeGusta(p)
	}

	def boolean puedeVer(Perfil preguntado, Perfil preguntando) {
		visibility.puedeVer(preguntado, preguntando)
	}

	def cantidadMeGusta() {
		likesAdmin.cantidadDeMeGusta()
	}

	def cantidadNoMeGusta() {
		likesAdmin.cantidadDeNoMeGusta()
	}
}

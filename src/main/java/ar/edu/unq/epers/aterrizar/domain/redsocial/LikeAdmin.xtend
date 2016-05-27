package ar.edu.unq.epers.aterrizar.domain.redsocial

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.exceptions.NoPuedesVotarException

//esta clase existe para no repetir codigo en postDestino y comment
@Accessors
class LikeAdmin {

	List<Like> meGusta
	List<Like> noMeGusta

	new() {
		meGusta = new ArrayList<Like>()
		noMeGusta = new ArrayList<Like>()
	}

	//modificar el contains o el equals de los likes o usar uno que no necesite el perfil dentro de un like
	def boolean puedeVotar(Perfil p, List<Like> likes) {
		for (like : likes) {
			if(like.id == p.idPerfil) {
				return false
			}
		}
		true
	}

	//que se rompa si no puede agregar
	def void agregarMeGusta(Perfil p) {
		validarVoto(p)
		agregarLike(p, meGusta)
	}

	def void validarVoto(Perfil p) {
		if(!(puedeVotar(p, meGusta) && puedeVotar(p, noMeGusta))) {
			throw new NoPuedesVotarException("No puedes agregar tu meGusta o noMeGusta")
		}
	}

	def void agregarNoMeGusta(Perfil p) {
		validarVoto(p)
		agregarLike(p, noMeGusta)
	}

	def void agregarLike(Perfil perfil, List<Like> likes) {
		likes.add(new Like(perfil))
	}

	def cantidadDeMeGusta() {
		meGusta.length
	}

	def cantidadDeNoMeGusta() {
		noMeGusta.length
	}

}

package ar.edu.unq.epers.aterrizar.domain

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
	def puedeVotar(Perfil p, List<Like> likes) {
		!likes.contains(p)
	}

	//que se rompa si no puede agregar
	def agregarMeGusta(Perfil p) {
		validarVotoMeGusta(p)
		agregarLike(p, meGusta)
	}

	def validarVotoMeGusta(Perfil p) {
		if(puedeVotar(p, meGusta) && !puedeVotar(p, noMeGusta)) {
			throw new NoPuedesVotarException("No puedes agregar tu meGusta o noMeGusta")
		}
	}

	def validarVotoNoMeGusta(Perfil p) {
		if(!puedeVotar(p, meGusta) && puedeVotar(p, noMeGusta)) {
			throw new NoPuedesVotarException("No puedes agregar tu meGusta o noMeGusta")
		}
	}

	def agregarNoMeGusta(Perfil p) {
		validarVotoNoMeGusta(p)
		agregarLike(p, noMeGusta)
	}

	def agregarLike(Perfil perfil, List<Like> likes) {
		likes.add(new Like(perfil))
	}

}

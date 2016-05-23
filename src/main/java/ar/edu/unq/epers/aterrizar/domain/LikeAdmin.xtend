package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList


//esta clase existe para no repetir codigo en postDestino y comment
@Accessors
class LikeAdmin {
	
	List<Like> meGusta
	List<Like> noMeGusta
	
	new(){
		meGusta = new ArrayList<Like>()
		noMeGusta = new ArrayList<Like>()
	}
	
	//modificar el contains o el equals de los likes o usar uno que no necesite el perfil dentro de un like
	def puedeVotar(Perfil p, List<Like> likes){
		!likes.contains(p)
	}
	//que se rompa si no puede agregar
	def agregarMeGusta(Perfil p){
		if(puedeVotar(p, meGusta)){
			agregarLike(p, meGusta)
		}
	}

	def agregarNoMeGusta(Perfil p){
		if(puedeVotar(p, noMeGusta)){
			agregarLike(p, noMeGusta)
		}
	}
	
	def agregarLike(Perfil perfil, List<Like> likes) {
		likes.add(new Like(perfil))
	}
	
}
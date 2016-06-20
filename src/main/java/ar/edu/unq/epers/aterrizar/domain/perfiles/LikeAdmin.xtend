package ar.edu.unq.epers.aterrizar.domain.perfiles
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.exceptions.NoPuedesVotarException
import com.datastax.driver.mapping.annotations.UDT
import com.datastax.driver.mapping.annotations.Field
import com.datastax.driver.mapping.annotations.Frozen

//esta clase existe para no repetir codigo en postDestino y comment
@Accessors
@UDT(keyspace = "aterrizar", name="likeAdmin")
class LikeAdmin {

	@Field(name = "meGusta")
	@Frozen("list<frozen <comment>>")
	List<Like> meGusta = new ArrayList<Like>()
	@Field(name = "noMeGusta")
	@Frozen("list<frozen <comment>>")
	List<Like> noMeGusta = new ArrayList<Like>()

	new() {
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
	
	def void quitarMeGusta(Perfil p){
		quitarLike(p, meGusta)
	}
	def void quitarNoMeGusta(Perfil p){
		quitarLike(p, noMeGusta)
	}
	
	def quitarLike(Perfil perfil, List<Like> likes) {
		likes.remove(new Like(perfil))
	}
	
	def cantidadDeMeGusta() {
		meGusta.length
	}

	def cantidadDeNoMeGusta() {
		noMeGusta.length
	}

}

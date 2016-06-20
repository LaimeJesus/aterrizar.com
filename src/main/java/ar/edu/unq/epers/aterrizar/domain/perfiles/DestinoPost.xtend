package ar.edu.unq.epers.aterrizar.domain.perfiles
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.exceptions.NoExisteEseComentarioException
import com.datastax.driver.mapping.annotations.UDT
import com.datastax.driver.mapping.annotations.Field
import com.datastax.driver.mapping.annotations.Frozen
import ar.edu.unq.epers.aterrizar.domain.perfiles.visibility.Visibility

@Accessors
@UDT(keyspace="aterrizar", name="destinoPost")
class DestinoPost {

	@Field(name="id")
	String id = ""
	@Field(name="comments")
	@Frozen("list<frozen <comment>>")
	List<Comment> comments = new ArrayList<Comment>()
	@Field(name="likesAdmin")
	@Frozen
	LikeAdmin likesAdmin = new LikeAdmin()
	@Field(name="visibility")
	Visibility visibility = Visibility.PRIVATE
	@Field(name="destino")
	String destino = ""

	new() {
	}

	new(String actualId, String destination) {
		id = actualId
		destino = destination
		comments = new ArrayList<Comment>()
		likesAdmin = new LikeAdmin()
		visibility = Visibility.PRIVATE
	}

	def addComment(Comment c) {
		comments.add(c)
	}

	def deleteComment(Comment c) {
		comments.remove(c)
	}

	def getComment(Comment c) {
		for (comment : comments) {
			if(comment.id == c.id) {
				return comment
			}
		}
		throw new NoExisteEseComentarioException("No Existe el comentario: " + c.comment)
	}

	def void meGusta(Perfil p) {
		likesAdmin.agregarMeGusta(p)
	}

	def void noMeGusta(Perfil p) {
		likesAdmin.agregarNoMeGusta(p)
	}
	
	def void quitarMeGusta(Perfil p){
		getLikesAdmin.quitarMeGusta(p)
	}

	def void quitarNoMeGusta(Perfil p){
		getLikesAdmin.quitarNoMeGusta(p)
	}

	def cantidadMeGusta() {
		likesAdmin.cantidadDeMeGusta()
	}

	def cantidadNoMeGusta() {
		likesAdmin.cantidadDeNoMeGusta()
	}

	def cambiarAPublico(Comment comment) {
		Visibility.PUBLIC.changeTo(this.getComment(comment))
	}

	def cambiarAPrivado(Comment comment) {
		Visibility.PRIVATE.changeTo(this.getComment(comment))
	}

	def cambiarASoloAmigos(Comment comment) {
		Visibility.ONLYFRIENDS.changeTo(this.getComment(comment))
	}

}

package ar.edu.unq.epers.aterrizar.domain.redsocial

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.domain.redsocial.LikeAdmin
import ar.edu.unq.epers.aterrizar.domain.redsocial.visibility.Visibility
import ar.edu.unq.epers.aterrizar.exceptions.NoExisteEseComentarioException

@Accessors
class DestinoPost {
	
	String id
	List<Comment> comments
	LikeAdmin likesAdmin
	Visibility visibility
	
	String destino
	
	new(){}
	
	new(String actualId, String destination){
		id = actualId
		destino = destination
		comments = new ArrayList<Comment>()
		likesAdmin = new LikeAdmin()
		visibility = Visibility.PRIVATE
	}
	
	def addComment(Comment c){
		comments.add(c)
	}
	
	def deleteComment(Comment c){
		comments.remove(c)
	}
	
	def getComment(Comment c){
		for(comment : comments){
			if(comment.id == c.id){
				return comment
			}		
		}
		throw new NoExisteEseComentarioException("No Existe el comentario: " + c.comment)
	}
	
	def void meGusta(Perfil p){
		likesAdmin.agregarMeGusta(p)
	}
	def void noMeGusta(Perfil p){
		likesAdmin.agregarNoMeGusta(p)
	}
	
	def cantidadMeGusta() {
		likesAdmin.cantidadDeMeGusta()
	}

	def cantidadNoMeGusta() {
		likesAdmin.cantidadDeNoMeGusta()
	}
	
	def cambiarAPublico(Comment comment) {
		Visibility.changeToPublic(this.getComment(comment))
	}
	
	def cambiarAPrivado(Comment comment) {
		Visibility.changeToPrivate(this.getComment(comment))
	}
	
	def cambiarASoloAmigos(Comment comment) {
		Visibility.changeToJustFriend(this.getComment(comment))
	}
	
}
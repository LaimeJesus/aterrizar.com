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
		throw new NoExisteEseComentarioException("No Existe " + c.id)
	}
	
	def void meGusta(Perfil p){
		likesAdmin.agregarMeGusta(p)
	}
	def void noMeGusta(Perfil p){
		likesAdmin.agregarNoMeGusta(p)
	}
	
	def boolean puedeVer(Perfil preguntado, Perfil preguntando) {
		visibility.puedeVer(preguntado, preguntando)
	}
	
	def void filtrarComentarios(Perfil preguntado, Perfil preguntando) {
		this.comments = comments.filter[it.puedeVer(preguntado, preguntando)].toList
	}
	
	def cantidadMeGusta() {
		likesAdmin.cantidadDeMeGusta()
	}

	def cantidadNoMeGusta() {
		likesAdmin.cantidadDeNoMeGusta()
	}

	
}
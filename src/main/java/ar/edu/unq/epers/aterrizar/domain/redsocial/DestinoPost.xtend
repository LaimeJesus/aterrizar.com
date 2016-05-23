package ar.edu.unq.epers.aterrizar.domain.redsocial

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.domain.redsocial.Comment
import ar.edu.unq.epers.aterrizar.domain.redsocial.LikeAdmin
import ar.edu.unq.epers.aterrizar.domain.redsocial.Visibility
import ar.edu.unq.epers.aterrizar.domain.redsocial.Private
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil

@Accessors
class DestinoPost {
	
	List<Comment> comments
	LikeAdmin likesAdmin
	Visibility visibility
	
	String destino
	
	new(){}
	
	new(String msg){
		destino = msg
		comments = new ArrayList<Comment>()
		likesAdmin = new LikeAdmin()
		visibility = new Private()
	}
	
	def addComment(Comment c){
		comments.add(c)
	}
	
	def deleteComment(Comment c){
		comments.remove(c)
	}
	
	def getComment(Comment c){
		comments.get(comments.indexOf(c))
	}
	
	def void meGusta(Perfil p){
		likesAdmin.agregarMeGusta(p)
	}
	def void noMeGusta(Perfil p){
		likesAdmin.agregarNoMeGusta(p)
	}
	
	def puedeVer(Perfil preguntado, Perfil preguntando) {
		visibility.puedeVer(preguntado, preguntando)
	}
	
	def void filtrarComentarios(Perfil preguntado, Perfil preguntando) {
		this.comments = comments.filter[it.puedeVer(preguntado, preguntando)].toList
	}
	
}

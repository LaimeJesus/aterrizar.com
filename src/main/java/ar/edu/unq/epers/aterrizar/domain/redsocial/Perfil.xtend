package ar.edu.unq.epers.aterrizar.domain.redsocial

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId
import com.fasterxml.jackson.annotation.JsonProperty
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.domain.redsocial.visibility.Visibility;
import ar.edu.unq.epers.aterrizar.exceptions.NoExistePostException

@Accessors
class Perfil {

	List<DestinoPost> posts
	@ObjectId
	@JsonProperty("_id")
	String idPerfil
	String nickname

	new() {
	}

	new(String nick) {
		posts = new ArrayList<DestinoPost>()
		nickname = nick
	}

	///////////////////////////////////////
	//POSTS
	///////////////////////////////////////
	def configVisibilityIntoPublic(DestinoPost p) {
		p.visibility = Visibility.PUBLIC
	}

	def configVisibilityIntoPublic(DestinoPost p, Comment c) {
		p.getComment(c).visibility = Visibility.PUBLIC
	}

	def configVisibilityIntoPrivate(DestinoPost p) {
		p.visibility = Visibility.PRIVATE
	}

	def addPost(DestinoPost p) {
		posts.add(p)
	}

	def deletePost(DestinoPost p) {
		posts.remove(p)
	}

	///////////////////////////////////////
	//COMMENTS
	///////////////////////////////////////
	def configVisibilityIntoPrivate(DestinoPost p, Comment c) {
		p.getComment(c).visibility = Visibility.PRIVATE
	}

	def configVisibilityIntoJustFriends(DestinoPost p) {
		p.visibility = Visibility.JUSTFRIENDS
	}

	def configVisibilityIntoJustFriends(DestinoPost p, Comment c) {
		p.getComment(c).visibility = Visibility.JUSTFRIENDS
	}

	def void commentToPost(DestinoPost post, Comment comment) {

		var p = getPost(post)
		p.addComment(comment)
	}

	def getPost(DestinoPost p) {
		for (post : posts) {
			System.out.println(post.id)
			if(post.id == p.id) {
				return post
			}
		}
		throw new NoExistePostException("No existe " + p.id)
	}

	def void agregarMeGusta(DestinoPost p) {
		getPost(p).meGusta(this)
	}

	def void agregarNoMeGusta(DestinoPost p) {
		getPost(p).noMeGusta(this)
	}

	def void agregarMeGusta(DestinoPost p, Comment c) {
		getPost(p).getComment(c).meGusta(this)
	}

	def void agregarNoMeGusta(DestinoPost p, Comment c) {
		getPost(p).getComment(c).noMeGusta(this)
	}

	//ver perfil
	def getContents(Perfil preguntando) {
		var res = new Perfil()
		var ps = posts.filter[it.puedeVer(this, preguntando)].toList
		ps.forEach[it.filtrarComentarios(this, preguntando)]
		res.posts = ps
		res
	}

	def getComments(DestinoPost post) {
		getPost(post).comments
	}
	def cantidadDeMeGusta(DestinoPost post){
		getPost(post).cantidadMeGusta()
	}
}

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
		posts = new ArrayList<DestinoPost>()
	}

	new(String nick) {
		posts = new ArrayList<DestinoPost>()
		nickname = nick
	}

	///////////////////////////////////////
	//POSTS
	///////////////////////////////////////
	def void configVisibilityIntoPublic(DestinoPost p) {

		Visibility.changeToPublic(getPost(p))
	}

	def void configVisibilityIntoPrivate(DestinoPost p) {
		Visibility.changeToPrivate(getPost(p))
	}

	def void configVisibilityIntoJustFriends(DestinoPost p) {
		Visibility.changeToJustFriend(getPost(p))
	}

	def addPost(DestinoPost p) {
		posts.add(p)
	}

	def deletePost(DestinoPost p) {
		posts.remove(p)
	}

	def getPost(DestinoPost p) {
		for (post : posts) {
			if(post.destino == p.destino) {
				return post
			}
		}
		throw new NoExistePostException("No existe " + p.id)
	}

	///////////////////////////////////////
	//COMMENTS
	///////////////////////////////////////
	def void configVisibilityIntoPrivate(DestinoPost p, Comment c) {
		Visibility.changeToPrivate(p.getComment(c))
	}

	def void configVisibilityIntoPublic(DestinoPost p, Comment c) {
		Visibility.changeToPublic(p.getComment(c))
	}

	def void configVisibilityIntoJustFriends(DestinoPost p, Comment c) {
		Visibility.changeToJustFriend(p.getComment(c))
	}

	def void commentToPost(DestinoPost post, Comment comment) {

		getPost(post).addComment(comment)
	}

	///////////////////////////////////////
	//likes
	///////////////////////////////////////
	def void agregarMeGusta(Perfil perfil, DestinoPost post) {
		getPost(post).meGusta(perfil)
	}

	def void agregarNoMeGusta(Perfil perfil, DestinoPost post) {
		getPost(post).noMeGusta(perfil)
	}

	def void agregarMeGusta(Perfil per, DestinoPost p, Comment c) {
		getPost(p).getComment(c).meGusta(per)
	}

	def void agregarNoMeGusta(Perfil per, DestinoPost p, Comment c) {
		getPost(p).getComment(c).noMeGusta(per)
	}

	//ver perfil
	def getContents(Perfil preguntando) {
		var res = new Perfil()

		var ps = this.posts.filter[it.puedeVer(this, preguntando)].toList
		ps.forEach[it.filtrarComentarios(this, preguntando)]
		res.posts = ps
		res
	}

	def getComments(DestinoPost post) {
		getPost(post).comments
	}

	def cantidadDeMeGusta(DestinoPost post) {
		getPost(post).cantidadMeGusta()
	}

	def cantidadDeMeGusta(DestinoPost post, Comment c) {
		getPost(post).getComment(c).cantidadMeGusta()
	}

	def cantidadDeNoMeGusta(DestinoPost p) {
		getPost(p).cantidadNoMeGusta()
	}
	def cantidadDeNoMeGusta(DestinoPost post, Comment c) {
		getPost(post).getComment(c).cantidadNoMeGusta()
	}
}

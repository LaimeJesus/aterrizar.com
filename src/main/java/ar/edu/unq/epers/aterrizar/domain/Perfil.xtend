package ar.edu.unq.epers.aterrizar.domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId
import com.fasterxml.jackson.annotation.JsonProperty
import java.util.ArrayList

@Accessors
class Perfil {
	
	List<DestinoPost> posts
	@ObjectId
	@JsonProperty("_id")
	String idPerfil
	String nickname

	new(){

	}

	new(String nick){
		posts = new ArrayList<DestinoPost>()
		nickname = nick
	}
	
	///////////////////////////////////////
	//POSTS
	///////////////////////////////////////

	def configVisibilityIntoPublic(DestinoPost p){
		p.visibility = new Public
	}
	def configVisibilityIntoPublic(DestinoPost p, Comment c){
		p.getComment(c).visibility = new Public
	}
	def configVisibilityIntoPrivate(DestinoPost p){
		p.visibility = new Private
	}
	def addPost(DestinoPost p){
		posts.add(p)
	}

	def deletePost(DestinoPost p){
		posts.remove(p)
	}
	///////////////////////////////////////
	//COMMENTS
	///////////////////////////////////////
	def configVisibilityIntoPrivate(DestinoPost p, Comment c){
		p.getComment(c).visibility = new Private
	}
	def configVisibilityIntoJustFriends(DestinoPost p){
		p.visibility = new JustFriends
	}
	def configVisibilityIntoJustFriends(DestinoPost p, Comment c){
		p.getComment(c).visibility = new JustFriends
	}
	
	def void commentToPost(DestinoPost post, Comment comment) {
		getPost(post).addComment(comment)
	}
	
	def getPost(DestinoPost p) {
		posts.get(posts.indexOf(p))
	}
	def void agregarMeGusta(DestinoPost p){
		getPost(p).meGusta(this)
	}
	def void agregarNoMeGusta(DestinoPost p){
		getPost(p).noMeGusta(this)
	}
	def void agregarMeGusta(DestinoPost p, Comment c){
		getPost(p).getComment(c).meGusta(this)
	}
	def void agregarNoMeGusta(DestinoPost p, Comment c){
		getPost(p).getComment(c).noMeGusta(this)
	}
	
	//ver perfil
	def getContents(Perfil preguntando){
		var res = new Perfil()
		var ps = posts.filter[it.puedeVer(this, preguntando)].toList
		ps.forEach[it.filtrarComentarios(this, preguntando)]
		res.posts = ps
		res
	}
}
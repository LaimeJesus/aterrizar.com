package ar.edu.unq.epers.aterrizar.domain.redsocial

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId
import com.fasterxml.jackson.annotation.JsonProperty
import java.util.ArrayList

@Accessors
class Perfil {
	
	List<Post> posts
	@ObjectId
	@JsonProperty("_nickname")
	String nickname

	new(){

	}

	new(String nick){
		posts = new ArrayList<Post>()
		nickname = nick
	}
	
	///////////////////////////////////////
	//POSTS
	///////////////////////////////////////

	def configVisibilityIntoPublic(Post p){
		p.visibility = new Public
	}
	def configVisibilityIntoPublic(Post p, Comment c){
		p.getComment(c).visibility = new Public
	}
	def configVisibilityIntoPrivate(Post p){
		p.visibility = new Private
	}
	def addPost(Post p){
		posts.add(p)
	}

	def deletePost(Post p){
		posts.remove(p)
	}
	///////////////////////////////////////
	//COMMENTS
	///////////////////////////////////////
	def configVisibilityIntoPrivate(Post p, Comment c){
		p.getComment(c).visibility = new Private
	}
	def configVisibilityIntoJustFriends(Post p){
		p.visibility = new JustFriends
	}
	def configVisibilityIntoJustFriends(Post p, Comment c){
		p.getComment(c).visibility = new JustFriends
	}
	
	def void commentToPost(Post post, Comment comment) {
		getPost(post).addComment(comment)
	}
	
	def getPost(Post p) {
		posts.get(posts.indexOf(p))
	}
	def void agregarMeGusta(Post p){
		getPost(p).meGusta(this)
	}
	def void agregarNoMeGusta(Post p){
		getPost(p).noMeGusta(this)
	}
	def void agregarMeGusta(Post p, Comment c){
		getPost(p).getComment(c).meGusta(this)
	}
	def void agregarNoMeGusta(Post p, Comment c){
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

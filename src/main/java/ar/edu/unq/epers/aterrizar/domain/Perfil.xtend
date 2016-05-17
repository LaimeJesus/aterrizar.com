package ar.edu.unq.epers.aterrizar.domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId
import com.fasterxml.jackson.annotation.JsonProperty

@Accessors
class Perfil {
	
	List<Post> posts
	@ObjectId
	@JsonProperty("_username")
	String username
	
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
}
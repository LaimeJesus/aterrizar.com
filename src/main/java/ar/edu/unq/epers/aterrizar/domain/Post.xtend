package ar.edu.unq.epers.aterrizar.domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList

@Accessors
class Post {
	
	List<Comment> comments
	LikeAdmin likesAdmin
	Visibility visibility
	
	new(){
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
}
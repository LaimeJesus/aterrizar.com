package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Comment {
	
	LikeAdmin likesAdmin
	Visibility visibility
	String comment

	new (String msg){
		visibility = new Private()
		likesAdmin = new LikeAdmin()
		comment = msg
	}
}
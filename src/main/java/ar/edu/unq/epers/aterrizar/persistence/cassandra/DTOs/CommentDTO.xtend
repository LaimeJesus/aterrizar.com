package ar.edu.unq.epers.aterrizar.persistence.cassandra.DTOs

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.redsocial.visibility.Visibility

@Accessors
//@UDT(keyspace="aterrizar", name="Comment")
class CommentDTO {
	
	String id
	LikeAdminDTO likesAdmin
	Visibility visibility
	String comment
}

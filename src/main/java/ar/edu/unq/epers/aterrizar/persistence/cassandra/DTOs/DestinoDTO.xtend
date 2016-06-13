package ar.edu.unq.epers.aterrizar.persistence.cassandra.DTOs

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import ar.edu.unq.epers.aterrizar.domain.redsocial.visibility.Visibility

@Accessors
class DestinoDTO {

	String nickname

	Visibility visibility

	String id

	List<CommentDTO> comentarios
	LikeAdminDTO likesAdmin
	String destino

	new() {
	}
}

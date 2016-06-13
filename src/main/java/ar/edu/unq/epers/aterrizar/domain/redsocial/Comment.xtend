package ar.edu.unq.epers.aterrizar.domain.redsocial

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.redsocial.LikeAdmin
import ar.edu.unq.epers.aterrizar.domain.redsocial.visibility.Visibility
import com.datastax.driver.mapping.annotations.UDT
import com.datastax.driver.mapping.annotations.Field
import com.datastax.driver.mapping.annotations.Frozen

@Accessors
@UDT(keyspace="aterrizar", name="comment")
class Comment {
	
	@Field(name = "id")
	String id = ''
	@Field(name = "likesAdmin")
	@Frozen
	LikeAdmin likesAdmin = new LikeAdmin()
	@Field(name = "visiblity")
	Visibility visibility = Visibility.PRIVATE
	@Field(name = "comment")
	String comment = ''

	new() {
	}

	new(String actualId, String msg) {
		id = actualId
		visibility = Visibility.PRIVATE
		likesAdmin = new LikeAdmin()
		comment = msg
	}

	def void meGusta(Perfil p) {
		likesAdmin.agregarMeGusta(p)
	}

	def void noMeGusta(Perfil p) {
		likesAdmin.agregarNoMeGusta(p)
	}

	def cantidadMeGusta() {
		likesAdmin.cantidadDeMeGusta()
	}

	def cantidadNoMeGusta() {
		likesAdmin.cantidadDeNoMeGusta()
	}
}

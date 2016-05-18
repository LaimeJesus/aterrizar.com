package ar.edu.unq.epers.aterrizar.persistence.hibernate

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.exceptions.UsuarioNoExisteException

class RepositorioUsuarioHibernate extends RepositorioHibernate<Usuario> {
	
	override getTable() {
		"Usuario"
	}
	
	override objectDoesnotExist() {
		throw new UsuarioNoExisteException()
	}
	
}
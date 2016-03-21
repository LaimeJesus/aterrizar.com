package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.domain.Usuario

class RepositorioUsuario implements Repositorio<Usuario>{
	
	override def void persistir(Usuario usr) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override def void borrar(Usuario usr) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override def Usuario traer(Usuario usr) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override def boolean contiene(Usuario usr, String field) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}
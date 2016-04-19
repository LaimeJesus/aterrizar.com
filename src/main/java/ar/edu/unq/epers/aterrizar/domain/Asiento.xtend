package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria

@Accessors

class Asiento {
	TipoDeCategoria categoria
	int idAsiento
	Usuario reservadoPorUsuario
	
	new(){
		
	}
	
	new(TipoDeCategoria cat, int precioCat){
		reservadoPorUsuario = null
		cat.factorPrecio = precioCat
		categoria = cat
	}
	def isReservado(){
		return reservadoPorUsuario != null
	}
	
	def precio() {
		return categoria.factorPrecio
	}
	
	def reservarPor(Usuario usuario) {
		reservadoPorUsuario = usuario
	}
	
}
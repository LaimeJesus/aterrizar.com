package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.categorias.Categoria

@Accessors

class Asiento {
	Categoria categoria
	int idAsiento
	Usuario reservadoPorUsuario
	
	def isReservado(){
		return reservadoPorUsuario != null
	}
	
	def precio() {
		return categoria.factorPrecio
	}
	
}
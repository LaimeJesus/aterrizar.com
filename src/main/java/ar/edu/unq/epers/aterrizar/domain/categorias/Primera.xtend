package ar.edu.unq.epers.aterrizar.domain.categorias

import ar.edu.unq.epers.aterrizar.domain.categorias.Categoria

class Primera extends Categoria {
	
	override calcularPrecioDeLaReserva(float precioBase) {
		precioBase + this.factorPrecio
	}
	
}
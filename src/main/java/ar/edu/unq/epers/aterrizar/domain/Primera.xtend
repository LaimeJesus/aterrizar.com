package ar.edu.unq.epers.aterrizar.domain

import ar.edu.unq.epers.aterrizar.domain.TipoDeCategoria

class Primera extends TipoDeCategoria {
	
	override calcularPrecioDeLaReserva(float precioBase) {
		precioBase + this.factorPrecio
	}
	
}
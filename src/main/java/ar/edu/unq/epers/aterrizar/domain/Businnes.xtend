package ar.edu.unq.epers.aterrizar.domain

import ar.edu.unq.epers.aterrizar.domain.TipoDeCategoria

class Businnes extends TipoDeCategoria {
	
	override calcularPrecioDeLaReserva(float precioBase) {
		precioBase + this.factorPrecio
	}
	
}
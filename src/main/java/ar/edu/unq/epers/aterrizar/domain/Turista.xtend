package ar.edu.unq.epers.aterrizar.domain

import ar.edu.unq.epers.aterrizar.domain.TipoDeCategoria
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Turista extends TipoDeCategoria {
	
	override calcularPrecioDeLaReserva(float precioBase) {
	precioBase + this.factorPrecio	
	
	}
}
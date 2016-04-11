package ar.edu.unq.epers.aterrizar.domain.categorias

import ar.edu.unq.epers.aterrizar.domain.categorias.Categoria
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Turista extends Categoria {
	
	override calcularPrecioDeLaReserva(float precioBase) {
	precioBase + this.factorPrecio	
	
	}
}
package ar.edu.unq.epers.aterrizar.domain.categorias

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors

abstract class Categoria {
	
	float factorPrecio
	
	def abstract float calcularPrecioDeLaReserva(float precioBase)
}
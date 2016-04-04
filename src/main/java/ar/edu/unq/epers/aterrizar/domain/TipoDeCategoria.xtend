package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors

abstract class TipoDeCategoria {
	
	float factorPrecio
	
	def abstract float calcularPrecioDeLaReserva(float precioBase)
}
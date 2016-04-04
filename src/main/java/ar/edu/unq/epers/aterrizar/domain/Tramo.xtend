package ar.edu.unq.epers.aterrizar.domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors

class Tramo {
	int idTramo
	String destino
	String origen
	List<Asiento> asiento
	String idVuelo 
	float precioBase
	
	def calcularPrecio(Asiento unAsiento){
		unAsiento.categoria.calcularPrecioDeLaReserva(this.getPrecioBase)
	}
}
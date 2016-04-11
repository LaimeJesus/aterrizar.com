package ar.edu.unq.epers.aterrizar.domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList

@Accessors

class Tramo {
	int idTramo
	String destino
	String origen
	List<Asiento> asientos
	String idVuelo 
	float precioBase
	
	def calcularPrecioDeUnAsiento(Asiento unAsiento){
		return precioBase + unAsiento.precio()
	}
	
	def calcularCostoTotal(){
		var costo = 0.0
		for(Asiento a:asientos){
			costo = costo + this.calcularPrecioDeUnAsiento(a)
		}
		return costo
		
	}
	
	def getAsientosDisponibles(){
		var disponibles = new ArrayList<Asiento>()
		for(Asiento a : asientos){
			if(!a.isReservado()){
				disponibles.add(a)
			}
		}
		return disponibles
	}
	
	def isDisponible(){
		return this.getAsientosDisponibles().length()>0
	}
}
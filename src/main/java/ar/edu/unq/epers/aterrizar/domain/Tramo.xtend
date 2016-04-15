package ar.edu.unq.epers.aterrizar.domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import java.sql.Date

@Accessors

class Tramo {
	int idTramo
	String destino
	String origen
	List<Asiento> asientos
	float precioBase
	
	// Criterio
	Date fechaDeSalida
	Date fechaDeLlegada
	
	def calcularPrecioDeUnAsiento(Asiento unAsiento){
		return precioBase + unAsiento.precio()
	}
	
	def calcularCostoTotal(){
		var costo = 0.0
		for(Asiento a: asientos){
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
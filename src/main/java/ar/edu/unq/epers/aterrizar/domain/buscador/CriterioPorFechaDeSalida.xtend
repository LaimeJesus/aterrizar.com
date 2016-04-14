package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import java.sql.Date

class CriterioPorFechaDeSalida extends Criterio{
	
	Date salida
	
	new(Date salida){
		this.salida = salida
	}
	
	override satisface(Aerolinea a) {
		return true
	}
	
	override getCondicion() {
		//return "from Vuelo as vuelos join vuelos.tramos as tramos where tramos.fechaDeSalida ='" + salida.toString +"'"
	}
	
}
package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.Aerolinea

class CriterioPorOrigen extends Criterio{
	
	String origen
	
	new(String origen){
		this.origen = origen
	}
	
	override satisface(Aerolinea a) {
	
		return true	
	}
		
	override getCondicion() {
		return "from a.vuelosDisponibles as vuelo 
									join vuelo.tramos as tramos
									where tramos.origen = origen"
	}
	
	
	
}
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
		// agregar comillas simples al final como parte del parametro
		return "from Vuelo as vuelos join vuelos.tramos as tramos where tramos.origen ='" + origen +"'"
	}
	
	
	
}
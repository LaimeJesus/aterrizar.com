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
		return "tramos.origen = '" + origen +"'"
	}
	
	override getQuery() {
		return super.getQuery() + " where " + getCondicion()
	}
	
	
	
}
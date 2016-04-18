package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.Aerolinea

class CriterioPorDestino extends Criterio{
	
	String destino
	
	new(String destino){
		this.destino = destino
	}
	
	override satisface(Aerolinea a) {
		return true
	}
	
	override getCondicion() {
		return "tramos.destino = '" + destino +"'"
	}
	
	override getQuery() {
		return super.getQuery() + " where " + getCondicion()
	}
	
	

	
}
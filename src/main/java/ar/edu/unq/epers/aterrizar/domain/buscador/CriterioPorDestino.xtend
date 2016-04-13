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
		return "from Aerolinea as aerolinea join aerolinea.vuelos as vuelo join vuelo.tramos as tramo join where tramo.destino =" + destino
	}
	

	
}
package ar.edu.unq.epers.aterrizar.domain.buscador


class CriterioPorDestino extends Criterio{
	
	String destino
	
	new(String destino){
		this.destino = destino
	}
	override getCondicion() {
		return "tramos.destino = '" + destino +"'"
	}	
}
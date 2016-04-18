package ar.edu.unq.epers.aterrizar.domain.buscador


class CriterioPorOrigen extends Criterio{
	
	String origen
	
	new(String origen){
		this.origen = origen
	}
	
	override getCondicion() {
		return "tramos.origen = '" + origen +"'"
	}
		
}
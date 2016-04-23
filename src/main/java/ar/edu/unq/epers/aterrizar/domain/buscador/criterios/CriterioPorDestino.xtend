package ar.edu.unq.epers.aterrizar.domain.buscador.criterios

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioPorDestino extends Criterio{
	
	String destino
	new(){
		
	}
	new(String destino){
		this.destino = destino
	}
	override getCondicion() {
		return "tramos.destino = '" + destino +"'"
	}	
}
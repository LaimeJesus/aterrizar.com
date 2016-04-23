package ar.edu.unq.epers.aterrizar.domain.buscador.criterios

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioPorOrigen extends Criterio{
	
	String origen
	new(){
		
	}
	new(String origen){
		this.origen = origen
	}
	
	override getCondicion() {
		return "tramos.origen = '" + origen +"'"
	}
		
}
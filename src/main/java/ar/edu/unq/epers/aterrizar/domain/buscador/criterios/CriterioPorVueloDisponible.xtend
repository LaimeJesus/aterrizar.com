package ar.edu.unq.epers.aterrizar.domain.buscador.criterios

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioPorVueloDisponible extends Criterio{
	
	new(){
		
	}
	override getCondicion() {
		return "asientos.reservadoPorUsuario = null"
	}
	
}
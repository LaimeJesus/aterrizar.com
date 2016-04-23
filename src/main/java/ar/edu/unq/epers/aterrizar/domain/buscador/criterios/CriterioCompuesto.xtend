package ar.edu.unq.epers.aterrizar.domain.buscador.criterios

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioCompuesto extends Criterio{
	
	List<Criterio> criterios
	String operador
	new(){
		
	}
	new(List<Criterio> criterios) {
		this.criterios = criterios
	}
	
	override getCondicion() {		
		return this.intercalarCondiciones(operador, criterios)
	}	
	
}
package ar.edu.unq.epers.aterrizar.domain.buscador
import java.util.List
import ar.edu.unq.epers.aterrizar.domain.Aerolinea

class CriterioCompuestoPorConjuncion extends Criterio{
	
	List<Criterio> criterios
	
	new(List<Criterio> criterios){
		this.criterios = criterios
	}
	
	override satisface(Aerolinea aerolinea) {
		return criterios.forall[Criterio c | c.satisface(aerolinea)]
	}
	
	override getCondicion() {
		
		var condicion = intercalarCondiciones("and", criterios)
		
		return condicion
	}	
	
	override getQuery() {
		return super.getQuery() + " where " + getCondicion()
	}
	
}
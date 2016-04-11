package ar.edu.unq.epers.aterrizar.domain.buscador
import java.util.List
import ar.edu.unq.epers.aterrizar.domain.Aerolinea

class CriterioCompuestoPorDisjuncion extends Criterio{
		
	List<Criterio> criterios
	
	new(List<Criterio> criterios){
		this.criterios = criterios
	}
	
	override satisface(Aerolinea aerolinea) {
		return criterios.exists[Criterio c | c.satisface(aerolinea)]
	}
}
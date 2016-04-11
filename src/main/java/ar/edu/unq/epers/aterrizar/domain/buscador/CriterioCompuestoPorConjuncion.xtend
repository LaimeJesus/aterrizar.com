package ar.edu.unq.epers.aterrizar.domain.buscador
import java.util.List
import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import org.hibernate.criterion.Restrictions

class CriterioCompuestoPorConjuncion extends Criterio{
	
	List<Criterio> criterios
	
	new(List<Criterio> criterios){
		this.criterios = criterios
	}
	
	override satisface(Aerolinea aerolinea) {
		return criterios.forall[Criterio c | c.satisface(aerolinea)]
	}
	
	override getCondicion() {
		var condicion = ""
		for(Criterio c: criterios){
			condicion = condicion + "and" + c.getCondicion()
		}
		
		return condicion
	}
	
}
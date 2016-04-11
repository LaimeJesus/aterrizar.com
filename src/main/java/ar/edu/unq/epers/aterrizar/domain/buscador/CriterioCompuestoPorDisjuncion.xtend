package ar.edu.unq.epers.aterrizar.domain.buscador
import java.util.List
import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import org.hibernate.criterion.Restrictions

class CriterioCompuestoPorDisjuncion extends Criterio{
		
	List<Criterio> criterios
	
	new(List<Criterio> criterios){
		this.criterios = criterios
	}
	
	override satisface(Aerolinea aerolinea) {
		return criterios.exists[Criterio c | c.satisface(aerolinea)]
	}
	override getRestriccion() {
		var restricciones = criterios.get(0).getRestriccion
		for(Criterio c: criterios){
			restricciones = Restrictions.or(restricciones, c.getRestriccion)
		}
		
		return restricciones
	}
}
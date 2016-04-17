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
	override getCondicion() {
		return this.intercalar("or", criterios)
	}
	
	def intercalar(String operador, List<Criterio> criterios) {
		var res = ""
		for(Criterio criterio : criterios){
			res = res + criterio.getCondicion() + operador
		}
		
		var sizeDelNuevoStringMenosUno = res.length()-1
		res = res.substring(0, sizeDelNuevoStringMenosUno)
		System.out.println(res)
		return res
	}
	
	override getQuery() {
		return ""
	}
	
}
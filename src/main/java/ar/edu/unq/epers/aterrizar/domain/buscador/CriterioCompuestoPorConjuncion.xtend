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
		
		var condicion = this.intercalar("and", criterios)
		
		return condicion
	}	
	
	def intercalar(String operador,	List<Criterio> criterios) {
		var res = ""
		for(Criterio criterio : criterios){
			res = res + criterio.getCondicion() + ' ' + operador + ' '
		}
		
		var sizeDelNuevoStringMenosUno = res.length()-5
		res = res.substring(0, sizeDelNuevoStringMenosUno)
		System.out.println(res)
		return res
	}
	
}
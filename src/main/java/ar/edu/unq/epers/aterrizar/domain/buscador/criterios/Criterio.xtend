package ar.edu.unq.epers.aterrizar.domain.buscador.criterios

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Criterio {
	
	Integer idCriterio
	new(){
		
	}
	def Criterio and(Criterio c){
		return new CriterioCompuesto(this.crearGrupoDeCriterios(this, c)) => [
			operador = " and "
		]
	}
	def Criterio or(Criterio c){
		return new CriterioCompuesto(this.crearGrupoDeCriterios(this, c)) => [
			operador = " or "
		]
	}
	
	//metodo privado
	def List<Criterio> crearGrupoDeCriterios(Criterio criterio1, Criterio criterio2){
		var criterios = new ArrayList<Criterio>()
		criterios.add(criterio1)
		criterios.add(criterio2)
		return criterios
	}

	//dame tus restricciones
	def abstract String getCondicion()
	
	def intercalarCondiciones(String operador, List<Criterio> criterios) {
		criterios.map[it.condicion ].join(operador)
	}
	
}
package ar.edu.unq.epers.aterrizar.domain.buscador

import java.util.ArrayList
import java.util.List

abstract class Criterio {
	
	def Criterio componerPorConjuncion(Criterio c){
		return new CriterioCompuesto(this.crearGrupoDeCriterios(this, c)) => [
			operador = " and "
		]
	}
	def Criterio componerPorDisjuncion(Criterio c){
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
		var res = ""
		for(Criterio criterio : criterios){
			res = res + criterio.getCondicion() + ' ' + operador + ' '
		}
		
		var sizeDeLaQuerySinElUltimoOperador = res.length() - (operador.length + 2)
		res = res.substring(0, sizeDeLaQuerySinElUltimoOperador)
		return res
	}
	
}
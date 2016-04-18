package ar.edu.unq.epers.aterrizar.domain.buscador

import java.util.ArrayList
import java.util.List
import ar.edu.unq.epers.aterrizar.domain.Aerolinea

abstract class Criterio {
	
	def abstract boolean satisface(Aerolinea a)
	
	def Criterio componerPorConjuncion(Criterio c){
		return new CriterioCompuestoPorConjuncion(this.crearGrupoDeCriterios(this,c))
	}
	def Criterio componerPorDisjuncion(Criterio c){
		return new CriterioCompuestoPorDisjuncion(this.crearGrupoDeCriterios(this,c))
	}
	
	//metodo privado
	def List<Criterio> crearGrupoDeCriterios(Criterio criterio1, Criterio criterio2){
		var criterios = new ArrayList<Criterio>()
		criterios.add(criterio1)
		criterios.add(criterio2)
		return criterios
	}
	
	def String getQuery(){
		return "select distinct aerolinea.vuelos from Aerolinea as aerolinea join aerolinea.vuelos as vuelos join vuelos.tramos as tramos join tramos.asientos as asientos"
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
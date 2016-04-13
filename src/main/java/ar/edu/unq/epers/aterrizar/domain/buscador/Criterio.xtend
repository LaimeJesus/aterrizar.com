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
	
	//dame tus restricciones
	def abstract String getCondicion()
	
}
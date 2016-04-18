package ar.edu.unq.epers.aterrizar.utils

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OrdenadorDeQueries {
	
	String orden
	new(){
		orden = ""
	}
	
	def getQuery(){}
	
	def ordenarPorMenorCosto(){
		orden = orden + "vuelos.costoDeVuelo asc"
	}
	def ordenarPorMenorEscala(){
		orden = orden + "vuelos.tramos.size asc"
	}
	def ordenarPorMenorDuracion(){
		orden = orden + "vuelos.duracionDeVuelo asc"
	}
	
	def isOrden() {
		return orden != ""
	}
	
}
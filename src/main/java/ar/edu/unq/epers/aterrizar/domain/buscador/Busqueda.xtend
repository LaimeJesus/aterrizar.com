package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.Criterio
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.Orden
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Busqueda {
	
	Integer idBusqueda
	Criterio filtro
	Orden orden
	
	new(){
		filtro = null
		orden = null
	}
	new(Orden o){
		orden = o
	}
	new(Criterio f){
		filtro = f
	}
	new(Criterio f, Orden o){
		filtro = f
		orden = o
	}
	
	def getQueryBase(){
		return "select distinct vuelos from Aerolinea as aerolinea join aerolinea.vuelos as vuelos join vuelos.tramos as tramos join tramos.asientos as asientos"
	}
	
	def getCondicion(){
		return " where " + filtro.condicion
	}
	
	def getQuery(){
		var query = queryBase
		var condicion = armarCondicion()
		var ordenado = armarOrden()
		var queryAEjecutar = query + condicion + ordenado
 		return queryAEjecutar
	}
	
	def armarOrden() {
		if(orden != null){
			return " order by " + orden.ordenadoPor
		}
		else{
			return ""
		}
	}
	
	def armarCondicion() {
		if(filtro != null){
			return " where " + filtro.condicion
		}
		else{
			return ""
		}
	}
	
	def ordenarPor(Orden o) {
		orden = o
	}
	def filtrarPor(Criterio c){
		filtro = c
	}
		
}
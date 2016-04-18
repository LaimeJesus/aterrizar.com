package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import java.util.List

@Accessors
class BuscadorDeVuelos {
	
	RepositorioAerolinea aerolineas
	Orden orden
	
	new(RepositorioAerolinea repoAerolinea){
		aerolineas = repoAerolinea
		orden = null
	}
	
	def buscarPorCriterio(Criterio unCriterio){
		
		var res = SessionManager.runInSession
		[|
			var sesion = aerolineas.getSession()
			
			var query = ""
			
			if(orden != null){
				query = getQueryPorCriterioYOrden(unCriterio, orden)
			}
			else{
				query = getQueryPorCriterio(unCriterio)
			}
			System.out.println(query)
			var queryResultado = sesion.createQuery(query)
			
			queryResultado.list() as List<Vuelo>		
		]		
		return res
	}
	
	def String getQueryDeVuelos(){
		var query = "select distinct aerolinea.vuelos from Aerolinea as aerolinea join aerolinea.vuelos as vuelos join vuelos.tramos as tramos join tramos.asientos as asientos" 
		return query
	}
	
	def String getQueryPorCriterio(Criterio c){
		return queryDeVuelos + " where " + c.getCondicion
	}
	
	def String getQueryPorCriterioYOrden(Criterio c, Orden o){
		return getQueryPorCriterio(c) + " order by " + o.getOrdenadoPor()
	}
	
	def ordenarPor(Orden o){
		orden = o
	}
	def ordenarDeMenorAMayor(Orden o){
		orden = o
		orden.porMenorOrden()
	}
	def ordenarDeMayorAMenor(Orden o){
		orden = o
		orden.porMayorOrden()
	}
	def cancelarOrden(){
		orden = null
	}
	def String getQueryPorOrden(Orden o){
		return getQueryDeVuelos + " order by " + o.getOrdenadoPor()
	}

}
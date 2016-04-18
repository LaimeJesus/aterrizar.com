package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import java.util.List
import ar.edu.unq.epers.aterrizar.utils.OrdenadorDeQueries

@Accessors
class BuscadorDeVuelos {
	
	OrdenadorDeQueries ordenador
	String orden
	RepositorioAerolinea aerolineas
	
	new(RepositorioAerolinea repoAerolinea){
		aerolineas = repoAerolinea
		orden = null
	}
	
	def buscarPorCriterio(Criterio unCriterio){
		
		var res = SessionManager.runInSession
		[|
			var sesion = aerolineas.getSession()
			var query = getQuery() + " where " + unCriterio.getCondicion()
			System.out.println(query)
			if(!ordenador.isOrden()){
				query = query + ordenador.getQuery()
			}
			var queryResultado = sesion.createQuery(query)
			
			queryResultado.list() as List<Vuelo>		
		]
		System.out.println(res.length)
		
		return res
	}
	
	def String getQuery(){
		return "select distinct aerolinea.vuelos from Aerolinea as aerolinea join aerolinea.vuelos as vuelos join vuelos.tramos as tramos join tramos.asientos as asientos"
	}
	
	def ordenarPorMenorCosto() {
		ordenador.ordenarPorMenorCosto
	}
	
	def ordenarPorMenorEscala() {
		ordenador.ordenarPorMenorEscala
	}
	
	def ordenarPorMenorDuracion() {
		ordenador.ordenarPorMenorDuracion
	}
	

}
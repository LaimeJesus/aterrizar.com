package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import java.util.ArrayList

@Accessors
class BuscadorDeVuelos {
	
	ArrayList<Vuelo> vuelos
	
	RepositorioAerolinea aerolineas
	
	new(RepositorioAerolinea aerolineas){
		this.aerolineas = aerolineas
	}
	
	def buscarPorCriterio(Criterio unCriterio){
		
		SessionManager.runInSession[|
		var sesion = aerolineas.getSession() 
		var query = sesion.createQuery(unCriterio.getQuery())
		var resultados = query.list() as ArrayList<Vuelo>
		vuelos = resultados
		]
		for(Vuelo vuelo: vuelos){
			System.out.print(vuelo.nroVuelo)
			System.out.print("\n")
			System.out.print(vuelos.length)
			System.out.print("\n")
		}
		return vuelos
	}
	
	def ordenarPorMenorCosto(){
		return "order by vuelos.tramos.precioBase asc"		
	}
	def ordenarPorMenorEscala(){

	}
	def ordenarPorMenorDuracion(){

	}	
}
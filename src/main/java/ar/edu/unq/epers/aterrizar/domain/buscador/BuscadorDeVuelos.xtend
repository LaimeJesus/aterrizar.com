package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import java.util.ArrayList

@Accessors
class BuscadorDeVuelos {
	
	String orden
	RepositorioAerolinea aerolineas
	
	new(RepositorioAerolinea repoAerolinea){
		aerolineas = repoAerolinea
		orden = " order by "
	}
	
	def buscarPorCriterio(Criterio unCriterio){
		
		var res = SessionManager.runInSession
		[|
			var sesion = aerolineas.getSession()
			var query = unCriterio.getQuery()
			System.out.println(query)
			if(!orden.equals(" order by ")){
				query = query + orden
			}
			var queryResultado = sesion.createQuery(query)
			
			queryResultado.list() as ArrayList<Vuelo>		
		]
		System.out.println(res.length)
		
		return res
	}
	
	def ordenarPorMenorCosto(){
		orden = orden + "tramos.precioBase asc"		
	}
	def ordenarPorMenorEscala(){
		orden = orden + "tramos.size asc"
	}
	def ordenarPorMenorDuracion(){
		// que es la duracion
		orden = orden + "vuelos.duracionDeVuelo asc"
	}	
}
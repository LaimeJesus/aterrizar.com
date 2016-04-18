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
		orden = ""
	}
	
	def buscarPorCriterio(Criterio unCriterio){
		
		var res = SessionManager.runInSession
		[|
			var sesion = aerolineas.getSession()
			var query = unCriterio.getQuery()
			System.out.println(query)
			if(!orden.equals("")){
				query = query + ' ' + orden
			}
			var queryResultado = sesion.createQuery(query)
			
			queryResultado.list() as ArrayList<Vuelo>		
		]
		System.out.println(res.length)
		
		return res
	}
	
	def ordenarPorMenorCosto(){
		orden = "order by tramos.precioBase asc"		
	}
	def ordenarPorMenorEscala(){
		orden = "order by tramos.length"
	}
	def ordenarPorMenorDuracion(){
		// que es la duracion
		orden = ""
	}	
}
package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import java.util.List

@Accessors
class BuscadorDeVuelos {
	
	RepositorioAerolinea aerolineas
	
	new(){
		
	}
	
	new(RepositorioAerolinea repoAerolinea){
		aerolineas = repoAerolinea
	}

	
	def buscarVuelos(ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda b){
		var res = SessionManager.runInSession
		[|
			var sesion = aerolineas.getSession()
			var query = b.getQuery()
			var queryResultado = sesion.createQuery(query)
			
			queryResultado.list() as List<Vuelo>
			
		]
		return res
	}

}

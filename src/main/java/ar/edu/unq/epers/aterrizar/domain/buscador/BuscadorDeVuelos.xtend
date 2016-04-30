package ar.edu.unq.epers.aterrizar.domain.buscador

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

	
	def buscarVuelos(Busqueda b){
		var res = SessionManager.runInSession
		[|
			var sesion = aerolineas.getSession()
			var query = b.getQuery()
			System.out.println(query)
			var queryResultado = sesion.createQuery(query)
			
			queryResultado.list() as List<Vuelo>
			
		]
		return res
	}

}
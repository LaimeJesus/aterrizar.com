package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.SessionManager

@Accessors
class BuscadorDeVuelosDisponibles {
	
	
	RepositorioAerolinea aerolineas
	
	new(RepositorioAerolinea aerolineas){
		this.aerolineas = aerolineas
	}
	
	def buscarPorCriterio(Criterio unCriterio){
//		var criteria = SessionManager.getSession().createCriteria
		
	}
}
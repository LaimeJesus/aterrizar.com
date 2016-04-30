package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.domain.Aerolinea

class RepositorioAerolinea extends RepositorioHibernate<Aerolinea>{
	
	override getTable() {
		"Aerolinea"
	}
	

}
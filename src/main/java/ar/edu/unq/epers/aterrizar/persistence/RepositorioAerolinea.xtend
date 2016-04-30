package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import ar.edu.unq.epers.aterrizar.exceptions.AerolineaNoExisteException

class RepositorioAerolinea extends RepositorioHibernate<Aerolinea>{
	
	override getTable() {
		"Aerolinea"
	}
	
	override objectDoesnotExist() {
		throw new AerolineaNoExisteException("No existe esta aerolinea")
	}
	

}
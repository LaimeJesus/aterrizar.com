package ar.edu.unq.epers.aterrizar.persistence.hibernate

import ar.edu.unq.epers.aterrizar.exceptions.AerolineaNoExisteException
import ar.edu.unq.epers.aterrizar.domain.vuelos.Aerolinea

class RepositorioAerolinea extends RepositorioHibernate<Aerolinea>{
	
	override getTable() {
		"Aerolinea"
	}
	
	override objectDoesnotExist() {
		throw new AerolineaNoExisteException("No existe esta aerolinea")
	}
	

}
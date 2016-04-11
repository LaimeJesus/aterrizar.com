package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import org.hibernate.criterion.Restrictions

class CriterioPorOrigen extends Criterio{
	
	String origen
	
	new(String origen){
		this.origen = origen
	}
	
	override satisface(Aerolinea a) {
		return true
	}
	
	//dame tu restriccion
	override getRestriccion() {
		//un stmt sql que te permite seleccionar todas las aerolineas que cumpplan con este criterio
		var vuelos = "select vuelos from Aerolineas as a"
		
		
		return Restrictions.sqlRestriction()
	}
	
	
	
}
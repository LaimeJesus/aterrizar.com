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
		
	override getCondicion() {
		return ""
	}
	
	
	
}
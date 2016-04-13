package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import org.hibernate.engine.JoinSequence.Join

class CriterioPorOrigen extends Criterio{
	
	String origen
	
	new(String origen){
		this.origen = origen
	}
	
	override satisface(Aerolinea a) {
		from a.vuelosDisponibles as vuelo 
									Join vuelo.tramos as tramos
									where tramos.origen = origen
	}
		
	override getCondicion() {
		return ""
	}
	
	
	
}
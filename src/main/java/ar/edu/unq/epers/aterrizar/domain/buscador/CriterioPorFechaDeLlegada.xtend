package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import java.sql.Date

class CriterioPorFechaDeLlegada extends Criterio{
	
	Date llegada
	
	new(Date llegada){
		this.llegada = llegada
	}
	
	override satisface(Aerolinea a) {
		return true
	}
	
	override getCondicion() {
		return ""
	}
	
}
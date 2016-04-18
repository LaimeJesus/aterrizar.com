package ar.edu.unq.epers.aterrizar.domain.buscador

import java.sql.Date

class CriterioPorFechaDeLlegada extends Criterio{
	
	Date llegada
	
	new(Date llegada){
		this.llegada = llegada
	}

	override getCondicion() {
		return "tramos.fechaDeLlegada = '" + llegada + "'"
	}
	
}
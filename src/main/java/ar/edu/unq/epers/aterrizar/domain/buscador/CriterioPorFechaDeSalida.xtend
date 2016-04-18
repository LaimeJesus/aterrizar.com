package ar.edu.unq.epers.aterrizar.domain.buscador

import java.sql.Date

class CriterioPorFechaDeSalida extends Criterio{
	
	Date salida
	
	new(Date salida){
		this.salida = salida
	}

	override getCondicion() {
		return "tramos.fechaDeSalida = '" + salida + "'"
	}

}
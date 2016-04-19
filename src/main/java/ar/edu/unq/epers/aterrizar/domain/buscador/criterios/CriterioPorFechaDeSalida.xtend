package ar.edu.unq.epers.aterrizar.domain.buscador.criterios

import java.sql.Date
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioPorFechaDeSalida extends Criterio{
	
	Date salida
	
	new(Date salida){
		this.salida = salida
	}

	override getCondicion() {
		return "tramos.fechaDeSalida = '" + salida + "'"
	}

}
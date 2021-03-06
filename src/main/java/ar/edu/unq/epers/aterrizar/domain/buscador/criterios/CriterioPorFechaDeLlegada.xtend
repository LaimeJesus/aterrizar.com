package ar.edu.unq.epers.aterrizar.domain.buscador.criterios

import java.sql.Date
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioPorFechaDeLlegada extends Criterio{
	
	Date llegada
	new(){
		
	}
	new(String unaFecha){
		llegada = Date.valueOf(unaFecha)
	}
	
	new(Date llegada){
		this.llegada = llegada
	}

	override getCondicion() {
		return "tramos.fechaDeLlegada = '" + llegada + "'"
	}
	
}
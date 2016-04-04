package ar.edu.unq.epers.aterrizar.domain

import java.sql.Date
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class PorFechaDeLlegada extends TipoDeCriterio{
	
	Date fechaLlegada
	
	override buscarPorCriterio(List<Aerolinea> tc) {
		
		List<Date> res = tc.get(0).vuelos.tramos.fechasDeLlegada()
		
		/*
		 * mismo procedimiento(FOR)
		 */
	}
	
	
	
}
package ar.edu.unq.epers.aterrizar.domain
import java.sql.Date
import java.util.List

class PorFechaDeSalida extends TipoDeCriterio{
	
	Date fecha
	
	override buscarPorCriterio(List<Aerolinea> tc) {
		
		var List<Date> res = tc.get(0).vuelos.tramo.fechasSalida()
		// filtrar-iterar
	}
	
	
}
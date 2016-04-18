package ar.edu.unq.epers.aterrizar.domain.buscador

class OrdenPorTrayecto extends Orden{
	
	String query = "vuelos.tramos.size"
	
	override porMenorOrden() {
		return query + " asc"
	}
	
	override porMayorOrden() {
		return query + " desc"
	}
	
	override getOrdenadoPor() {
		return query
	}
	
}
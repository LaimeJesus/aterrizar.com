package ar.edu.unq.epers.aterrizar.domain.buscador

class OrdenPorTrayecto extends Orden{
	
	String query = "vuelos.tramos.size"

	
	override getOrdenadoPor() {
		return query
	}

	override porMenorOrden() {
		query = query + " asc"
	}
	
	override porMayorOrden() {
		query = query + " desc"
	}
	
}
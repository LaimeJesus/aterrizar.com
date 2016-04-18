package ar.edu.unq.epers.aterrizar.domain.buscador

class OrdenPorDuracion extends Orden{
	
	String query = "vuelos.duracionDeVuelo asc"
	
	override porMenorOrden() {
		query = query + " asc"
	}
	
	override porMayorOrden() {
		query = query + " desc"
	}
	
	override getOrdenadoPor() {
		return query
	}
	
}
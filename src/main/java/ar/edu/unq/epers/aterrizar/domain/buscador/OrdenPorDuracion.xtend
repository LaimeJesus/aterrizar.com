package ar.edu.unq.epers.aterrizar.domain.buscador

class OrdenPorDuracion extends Orden{
	
	String query = "vuelos.duracionDeVuelo asc"
	
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
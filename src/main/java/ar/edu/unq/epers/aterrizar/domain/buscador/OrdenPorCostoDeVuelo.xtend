package ar.edu.unq.epers.aterrizar.domain.buscador

class OrdenPorCostoDeVuelo extends Orden{

	String query = "vuelos.costoDeVuelo"
	
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
package ar.edu.unq.epers.aterrizar.domain.buscador

class OrdenPorCostoDeVuelo extends Orden{

	String query = "vuelos.costoDeVuelo"
	
	override getOrdenadoPor() {
		return query
	}
	
	override porMenorOrden() {
		return query + " asc"
	}
	
	override porMayorOrden() {
		return query + " desc"
	}
	
}
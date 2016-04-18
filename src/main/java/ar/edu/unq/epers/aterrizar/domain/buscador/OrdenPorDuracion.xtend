package ar.edu.unq.epers.aterrizar.domain.buscador

class OrdenPorDuracion extends Orden{
	
	String query = "vuelos.duracionDeVuelo asc"
	
	
	override getOrdenadoPor() {
		return query
	}
	
}
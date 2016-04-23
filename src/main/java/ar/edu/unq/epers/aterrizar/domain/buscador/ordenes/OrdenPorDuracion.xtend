package ar.edu.unq.epers.aterrizar.domain.buscador.ordenes

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OrdenPorDuracion extends Orden{
	
	String query = "vuelos.duracionDeVuelo"
	
	new(){
		
	}
	def porMenorOrden() {
		query = query + " asc"
	}
	
	def porMayorOrden() {
		query = query + " desc"
	}
	
	override getOrdenadoPor() {
		return query
	}
	
}
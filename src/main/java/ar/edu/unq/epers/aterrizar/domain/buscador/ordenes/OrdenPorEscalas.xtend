package ar.edu.unq.epers.aterrizar.domain.buscador.ordenes

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OrdenPorEscalas extends Orden{
	
	String query = "vuelos.tramos.size"
	new(){
		
	}
	
	override getOrdenadoPor() {
		return query
	}

	def porMenorOrden() {
		query = query + " asc"
	}
	
	def porMayorOrden() {
		query = query + " desc"
	}
	
}
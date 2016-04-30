package ar.edu.unq.epers.aterrizar.domain.buscador.ordenes

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OrdenPorEscalas extends Orden{
	
	new(){
		orderBy = "vuelos.tramos.size"
		sortedBy = ""
	}
}
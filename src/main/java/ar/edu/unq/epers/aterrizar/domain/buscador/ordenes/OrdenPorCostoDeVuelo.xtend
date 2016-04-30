package ar.edu.unq.epers.aterrizar.domain.buscador.ordenes

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OrdenPorCostoDeVuelo extends Orden{

	new(){
		orderBy = "vuelos.costoDeVuelo"
		sortedBy = ""
	}
	
}
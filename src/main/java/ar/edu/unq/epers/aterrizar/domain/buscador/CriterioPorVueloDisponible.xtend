package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.Aerolinea

class CriterioPorVueloDisponible extends Criterio{
	
	
	override satisface(Aerolinea a) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override getCondicion() {
		var res = "from Vuelo as vuelos join vuelos.tramos as tramos join tramos.asientos as asientos where asientos.reservadoPorUsuario = null" 
		System.out.println(res)
		return res 
	}
	
}
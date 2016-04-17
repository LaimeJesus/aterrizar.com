package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.Aerolinea

class CriterioPorVueloDisponible extends Criterio{
	
	
	override satisface(Aerolinea a) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override getQuery(){
		var res = super.getQuery() + " where " + getCondicion()
//		return "from Vuelo as vuelos join vuelos.tramos as tramos join tramos.asientos as asientos where " + this.getCondicion()
		System.out.println(res)
		return res
	}
	
	override getCondicion() {
		//hay que agregar where en todas las condiciones
		
		var res = "asientos.reservadoPorUsuario = null"
		return res 
	}
	
}
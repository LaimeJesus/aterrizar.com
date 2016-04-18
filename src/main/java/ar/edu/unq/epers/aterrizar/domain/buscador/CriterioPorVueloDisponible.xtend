package ar.edu.unq.epers.aterrizar.domain.buscador


class CriterioPorVueloDisponible extends Criterio{
		
	override getCondicion() {
		return "asientos.reservadoPorUsuario = null"
	}
	
}
package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.Aerolinea

class CriterioPorNombreDeAerolinea extends Criterio{
	
	String nombre
	
	new(String nombre){
		this.nombre = nombre
	}
	
	override satisface(Aerolinea aerolinea) {
		return nombre.equals(aerolinea.nombreAerolinea)
	}
	
	override getCondicion() {
		return "select aerolinea.vuelos from Aerolinea as aerolinea where aerolinea.nombreAerolinea='" + nombre + "'"
	}
	
}
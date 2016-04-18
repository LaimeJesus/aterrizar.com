package ar.edu.unq.epers.aterrizar.domain.buscador

class CriterioPorNombreDeAerolinea extends Criterio{
	
	String nombre
	
	new(String nombre){
		this.nombre = nombre
	}
	override getCondicion() {
		//return "select aerolinea.vuelos from Aerolinea as aerolinea where aerolinea.nombreAerolinea='" + nombre + "'"
	
		return "aerolinea.nombreAerolinea = '" + nombre +"'"
	}
	
}
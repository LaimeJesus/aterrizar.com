package ar.edu.unq.epers.aterrizar.domain.buscador.criterios

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioPorNombreDeAerolinea extends Criterio{
	
	String nombre
	new(){
		
	}
	new(String nombre){
		this.nombre = nombre
	}
	override getCondicion() {
		//return "select aerolinea.vuelos from Aerolinea as aerolinea where aerolinea.nombreAerolinea='" + nombre + "'"
	
		return "aerolinea.nombreAerolinea = '" + nombre +"'"
	}
	
}
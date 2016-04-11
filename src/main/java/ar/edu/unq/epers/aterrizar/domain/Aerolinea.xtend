package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList

@Accessors
class Aerolinea {
	
	Integer idAerolinea
	String nombreAerolinea
	List<Vuelo> vuelos
	
	def vuelosDisponibles(){
		var disponibles = new ArrayList<Vuelo>()
		for(Vuelo v: vuelos){
			if(v.isDisponible){
				disponibles.add(v)
			}
		}
		return disponibles
	}
}
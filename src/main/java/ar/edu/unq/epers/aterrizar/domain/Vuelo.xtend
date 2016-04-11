package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List

@Accessors
class Vuelo {
	int idVuelo
	List<Tramo> tramos
	
	def isDirecto(){
		return tramos.length.equals(1)
	}
	
	def isDisponible(){
		var disponible = false
		for(Tramo t:tramos){
			disponible = disponible || t.isDisponible()
		}
		return disponible
	}
}
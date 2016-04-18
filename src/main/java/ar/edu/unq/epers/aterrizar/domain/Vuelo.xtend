package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList

@Accessors
class Vuelo {
	int idVuelo
	int nroVuelo
	List<Tramo> tramos
	
	long duracionDeVuelo
	
	new(){
		
	}
	
	new(int nroDeVuelo){
		nroVuelo = nroDeVuelo
		tramos = new ArrayList<Tramo>()
		duracionDeVuelo = 0L
	}

	
	def isDirecto(){
		return tramos.length.equals(1)
	}
	
	def isDisponible(){
		var disponible = true
		for(Tramo t: tramos){
			disponible = disponible && t.isDisponible()
		}
		return disponible
	}
	
	def equals(Vuelo v){
		return nroVuelo.equals(v.nroVuelo)
	}
	def agregarTramo(Tramo t){
		tramos.add(t)
		duracionDeVuelo = duracionDeVuelo + t.duracionDeTramo
	}
	def getDuracion(){
		var dur = 0L
		for(Tramo t: tramos){
			dur = dur + t.duracionDeTramo
		}
		return dur
	}
}
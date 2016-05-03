package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.exceptions.TramoNoExisteException

@Accessors
class Vuelo {
	int idVuelo
	int nroVuelo
	List<Tramo> tramos
	
	long duracionDeVuelo
	
	int costoDeVuelo
	
	new(){
		
	}
	
	new(int nroDeVuelo){
		nroVuelo = nroDeVuelo
		tramos = new ArrayList<Tramo>()
		duracionDeVuelo = 0L
		costoDeVuelo = 0
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
		costoDeVuelo = costoDeVuelo + t.precioBase
	}
	def getDuracion(){
		var dur = 0L
		for(Tramo t: tramos){
			dur = dur + t.duracionDeTramo
		}
		return dur
	}
	
	def removerTramo(Tramo tramo) {
		tramos.remove(tramo)
		duracionDeVuelo = duracionDeVuelo - tramo.duracionDeTramo
		costoDeVuelo = costoDeVuelo - tramo.precioBase
	}
	
	def contieneTramo(Tramo tramo){
		tramos.exists[it.equals(tramo)] 
	}
	
	def void validarReserva(Tramo tramo, Asiento asiento) throws TramoNoExisteException{

		if(!contieneTramo(tramo)){
			throw new TramoNoExisteException("no existe tramo " + tramo.nroTramo.toString)
		}
		tramo.validarReserva(asiento)

	}

}
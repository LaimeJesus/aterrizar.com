package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.exceptions.VueloNoExisteException

@Accessors
class Aerolinea {
	
	Integer idAerolinea
	String nombreAerolinea
	List<Vuelo> vuelos
	
	new(){
		
	}
	new(String nombre){
		nombreAerolinea = nombre
		vuelos = new ArrayList<Vuelo>()
	}
	
	def vuelosDisponibles(){
		var disponibles = new ArrayList<Vuelo>()
		for(Vuelo v: vuelos){
			if(v.isDisponible){
				disponibles.add(v)
			}
		}
		return disponibles
	}
	
	def agregarVuelo(Vuelo vuelo) {
		vuelos.add(vuelo)
	}
	
	def removerVuelo(Vuelo vuelo) {
		vuelos.remove(vuelo)
	}
	def contieneVuelo(Vuelo unVuelo){
//		vuelos.exists[it.equals(unVuelo)]
		vuelos.exists[Vuelo v|v.nroVuelo == unVuelo.nroVuelo]
	}
	
	def void validarReserva(Vuelo vuelo, Tramo tramo, Asiento asiento) throws VueloNoExisteException{
		if(!contieneVuelo(vuelo)) {
			throw new VueloNoExisteException("no existe vuelo " + vuelo.nroVuelo.toString)
		}
		vuelo.validarReserva(tramo,asiento)
	}
	
}
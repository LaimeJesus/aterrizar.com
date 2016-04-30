package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.exceptions.AerolineaNoExisteException

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
	
	def validarReserva(Vuelo vuelo, Tramo tramo, Asiento asiento) {
		
		if(!vuelos.exists[Vuelo v|v.nroVuelo == vuelo.nroVuelo]) {
			throw new AerolineaNoExisteException("no existe ese vuelo en esta aerolinea")
		}
		
		vuelo.validarReserva(tramo,asiento)
	}
	
}
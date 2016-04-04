package ar.edu.unq.epers.aterrizar.domain

import java.util.List

class Buscador {
	
	//TipoDeCriterio criterioDeBusqueda
	List<Aerolinea> vuelos
	
	new(){}
	
	def void buscar(TipoDeCriterio cs){
		
		cs.buscarPorCriterio(vuelos)
	}
	
	
}
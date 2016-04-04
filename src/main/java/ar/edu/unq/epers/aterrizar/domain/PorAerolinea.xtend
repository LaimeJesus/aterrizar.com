package ar.edu.unq.epers.aterrizar.domain

import java.util.List

class PorAerolinea extends TipoDeCriterio{
	
	Aerolinea name
	
	override boolean buscarPorCriterio(List<Aerolinea> tc) {
		name.nombreAerolinea == tc.get(0).nombreAerolinea
	}
	
	
	
}
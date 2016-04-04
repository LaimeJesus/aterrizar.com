package ar.edu.unq.epers.aterrizar.domain

import java.util.List

class PorCategoriaDeAsiento extends TipoDeCriterio{
	
	Asiento asiento
	
	override buscarPorCriterio(List<Aerolinea> tc) {
		
		var List<TipoDeCategoria> res = tc.get(0).vuelos.tramos.asiento.todasLasCategorias()
		
		/*
		 * ahora que tengo todas las categorias deberia poder filtrar por esa condicion
		 * a traves de algo q itere list(FOR)
		 * basicamente esta mal pedir el get de una lista de aerolineas, sabiendo q te llega
		 * una(cambiarlo)
		 * esta claro que usar get(0) no iria xq deberia llegar una Aerolinea
		 * 
		 * voy a necesitar un metodo que me de todas las categorias de todos los asientos de un tramo
		 */
		 
	}
	
	
	
}
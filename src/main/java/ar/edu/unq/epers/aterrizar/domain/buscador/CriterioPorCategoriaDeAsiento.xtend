package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria

class CriterioPorCategoriaDeAsiento extends Criterio{
	
	TipoDeCategoria categoria
	
	new(TipoDeCategoria cat){
		this.categoria = cat
	}
	
	override satisface(Aerolinea a) {
		return true
	}
	
	override getCondicion() {
		
	}
	
	override getQuery() {
		return ""
	}
	
}
package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria

class CriterioPorCategoriaDeAsiento extends Criterio{
	
	TipoDeCategoria categoria
	
	new(TipoDeCategoria cat){
		this.categoria = cat
	}
	
	override getCondicion() {
		return "asientos.cat = '" + categoria + "'"
	}
	
}
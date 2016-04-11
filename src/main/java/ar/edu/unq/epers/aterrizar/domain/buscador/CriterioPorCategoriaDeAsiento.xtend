package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import ar.edu.unq.epers.aterrizar.domain.categorias.Categoria

class CriterioPorCategoriaDeAsiento extends Criterio{
	
	Categoria categoria
	
	new(Categoria cat){
		this.categoria = cat
	}
	
	override satisface(Aerolinea a) {
		return true
	}
	
	override getCondicion() {
		
	}
	
}
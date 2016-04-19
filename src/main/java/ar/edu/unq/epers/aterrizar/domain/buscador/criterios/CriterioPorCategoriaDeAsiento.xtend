package ar.edu.unq.epers.aterrizar.domain.buscador.criterios

import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioPorCategoriaDeAsiento extends Criterio{
	
	TipoDeCategoria categoria
	
	new(TipoDeCategoria cat){
		this.categoria = cat
	}
	
	override getCondicion() {
		return "asientos.cat = '" + categoria + "'"
	}
	
}
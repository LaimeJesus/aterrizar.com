package ar.edu.unq.epers.aterrizar.domain.buscador.ordenes

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Orden {
	
	private Integer idOrden
	private String orderBy
	private String sortedBy
	
	new(){
		
	}
	def and(Orden ord){
		return new OrdenCompuesto(crearGrupoDeOrdenes(this, ord))
	}
	
	def List<Orden> crearGrupoDeOrdenes(Orden orden1, Orden orden2){
		var grupo = new ArrayList<Orden>()
		grupo.add(orden1)
		grupo.add(orden2)
		return grupo
	}

	def String getOrdenadoPor(){
		var res = this.getOrderBy() + "" + this.getSortedBy()
		res
	}
	
	def intercalarOrdenes(String operador, List<Orden> ordenes) {
		var res = String.join(operador, ordenes.map[c| c.getOrdenadoPor()])
		return res
	}
	def porMenorOrden() {
		sortedBy = " asc"
	}
	
	def porMayorOrden() {
		sortedBy = " desc"
	}
}
package ar.edu.unq.epers.aterrizar.domain.buscador

import java.util.ArrayList
import java.util.List

abstract class Orden {
	
	def componer(Orden ord){
		return new OrdenCompuesto(crearGrupoDeOrdenes(this, ord))
	}
	
	def List<Orden> crearGrupoDeOrdenes(Orden orden1, Orden orden2){
		var grupo = new ArrayList<Orden>()
		grupo.add(orden1)
		grupo.add(orden2)
		return grupo
	}
	def abstract String porMenorOrden()
	
	def abstract String porMayorOrden()
	
	def abstract String getOrdenadoPor()
	
	def intercalarOrdenes(String operador, List<Orden> ordenes) {
		var res = String.join(operador, ordenes.map[c| c.getOrdenadoPor()])
		return res
	}
}
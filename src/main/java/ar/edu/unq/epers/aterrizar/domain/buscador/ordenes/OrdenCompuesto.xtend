package ar.edu.unq.epers.aterrizar.domain.buscador.ordenes

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OrdenCompuesto extends Orden{
	
	List<Orden> grupoDeOrdenes
	String orderBy
	
	new(){
		
	}
	new(List<Orden> ordenes) {
		this.grupoDeOrdenes = ordenes
	}
	
	override getOrdenadoPor() {
		
		orderBy = intercalarOrdenes(",", grupoDeOrdenes)
		return orderBy
	}
	
	override def porMenorOrden() {
		grupoDeOrdenes.forEach[Orden o| o.porMenorOrden]
		null
	}
	
	override def porMayorOrden() {
		grupoDeOrdenes.forEach[Orden o| o.porMayorOrden]
		null
	}
	
}
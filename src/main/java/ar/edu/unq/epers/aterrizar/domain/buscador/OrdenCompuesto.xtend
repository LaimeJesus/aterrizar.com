package ar.edu.unq.epers.aterrizar.domain.buscador

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OrdenCompuesto extends Orden{
	
	List<Orden> grupoDeOrdenes
	
	new(List<Orden> ordenes) {
		this.grupoDeOrdenes = ordenes
	}
	
	override getOrdenadoPor() {
		return intercalarOrdenes(",", grupoDeOrdenes)
	}
	
	override porMenorOrden() {
		return intercalarOrdenes("asc,", grupoDeOrdenes)
	}
	
	override porMayorOrden() {
		return intercalarOrdenes("desc,", grupoDeOrdenes)	
	}
	
}
package ar.edu.unq.epers.aterrizar.domain.buscador

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OrdenCompuesto extends Orden{
	
	List<Orden> grupoDeOrdenes
	String query
	
	new(List<Orden> ordenes) {
		this.grupoDeOrdenes = ordenes
	}
	
	override getOrdenadoPor() {
		
		query = intercalarOrdenes(",", grupoDeOrdenes)
		return query
	}
	
	override porMenorOrden() {
		query = intercalarOrdenes(" asc,", grupoDeOrdenes)
	}
	
	override porMayorOrden() {
		query = intercalarOrdenes(" desc,", grupoDeOrdenes)	
	}
	
}
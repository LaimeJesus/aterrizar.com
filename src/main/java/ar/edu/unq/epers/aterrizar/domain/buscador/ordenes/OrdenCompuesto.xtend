package ar.edu.unq.epers.aterrizar.domain.buscador.ordenes

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OrdenCompuesto extends Orden{
	
	List<Orden> grupoDeOrdenes
	String query
	
	new(){
		
	}
	new(List<Orden> ordenes) {
		this.grupoDeOrdenes = ordenes
	}
	
	override getOrdenadoPor() {
		
		query = intercalarOrdenes(",", grupoDeOrdenes)
		return query
	}
	
	def porMenorOrden() {
		query = intercalarOrdenes(" asc,", grupoDeOrdenes)
	}
	
	def porMayorOrden() {
		query = intercalarOrdenes(" desc,", grupoDeOrdenes)	
	}
	
}
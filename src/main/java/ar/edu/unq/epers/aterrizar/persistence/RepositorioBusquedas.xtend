package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda
import java.util.List
import java.util.ArrayList

class RepositorioBusquedas extends RepositorioHibernate<Busqueda>{
	
	def traerBusquedas(){
		var stmt = stmtBase + " order by t.idBusqueda asc"
		val sesion = this.getSession()
		val query = sesion.createQuery(stmt)
		var busquedas = query.list() as List<Busqueda>
		if(busquedas.isEmpty){
			return new ArrayList<Busqueda>()
		}
		return busquedas
	}
	def traerUltimaBusqueda(){
		return traerBusquedas.head
	}
			
	override getTable() {
		"Busqueda"
	}
	
}
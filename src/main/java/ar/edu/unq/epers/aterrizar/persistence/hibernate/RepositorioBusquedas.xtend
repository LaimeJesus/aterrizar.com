package ar.edu.unq.epers.aterrizar.persistence.hibernate

import ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.exceptions.BusquedaNoExisteException

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
	
	override objectDoesnotExist() {
		throw new BusquedaNoExisteException("NO existe esta busqueda")
	}
	
}
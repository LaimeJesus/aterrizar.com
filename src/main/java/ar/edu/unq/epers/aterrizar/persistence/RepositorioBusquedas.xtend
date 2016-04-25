package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda
import java.util.List
import ar.edu.unq.epers.aterrizar.exceptions.BusquedaNoExisteException
import java.util.ArrayList

class RepositorioBusquedas extends Repositorio<Busqueda>{
	
	def getSession(){
		return SessionManager.getSession()
	}
	
	override persistir(Busqueda busqueda) {
		this.getSession().save(busqueda)
	}
	
	override borrar(String campo, String valor) {
		this.getSession().delete(this.traer(campo, valor))
	}

	override traer(String field, String value) {
		
		var stmt = "from Busqueda as b where b." + field + " = :" + field
		var query = this.getSession().createQuery(stmt)
		query.setParameter(field, value)
		var busquedas = query.list() //as ArrayList<Aerolinea>
		if(busquedas.isEmpty){
			return null
		}
		var busqueda = busquedas.head as Busqueda
		
		return busqueda
	}
	def traerBusquedas(){
		var stmt = "from Busqueda as b order by b.idBusqueda asc"
		val sesion = this.getSession()
		val query = sesion.createQuery(stmt)
		var busquedas = query.list() as List<Busqueda>
		if(busquedas.isEmpty){
			return null
		}
		return busquedas
	}
	def traerPorId(){
		return traerBusquedas.head
	}
	
	override contiene(String field, String value) {
		traer(field, value) != null
	}
	
	override actualizar(Busqueda busqueda, String field, String unique_value) {
		this.getSession.update(busqueda)
	}
	def actualizarBusqueda(Busqueda busqueda){
		actualizar(busqueda, "no importa", "no importa")
	}
	override objectNotFoundError() throws Exception {
		new BusquedaNoExisteException("no existe esa busqueda")
	}
	
	//deprecated
	override campos() {
		new ArrayList<String>()
	}
	//deprecated
	override valores(Busqueda obj) {
		return new ArrayList<String>()
	}
	
}
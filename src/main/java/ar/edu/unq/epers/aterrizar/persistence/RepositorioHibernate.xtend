package ar.edu.unq.epers.aterrizar.persistence

import java.util.List

abstract class RepositorioHibernate<T> {


	def abstract String getTable()

	def getSession(){
		SessionManager.getSession()
	}
	
	def void persistir(T unObject) {
		session.save(unObject)
	}
	
	def void actualizar(T object) {
		session.merge(object)
	}
	
	def void borrar(T object) {

		session.delete(object)
	}
	
	def T traer(String field, String value) {
		
		var stmt = stmtBase + " where t." + field + " = :" + field
		
		var query = session.createQuery(stmt)
		query.setParameter(field, value)
		
		var objects = query.list() as List<T>
		
		if(objects.isEmpty){
			return null
		}
		
		return objects.get(0)
	}
	
	def List<T> traerTodos(){
		var stmt = stmtBase
		var query = session.createQuery(stmt)		
		query.list as List<T>
	}

	def boolean contiene(String field, String value) {
		traer(field, value) != null
	}

	def getStmtBase(){
		"from " + getTable() + " as t"
	}
}
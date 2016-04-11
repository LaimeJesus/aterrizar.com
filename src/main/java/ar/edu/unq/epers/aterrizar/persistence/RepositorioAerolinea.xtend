package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.exceptions.AerolineaNoExisteException

class RepositorioAerolinea extends Repositorio<Aerolinea>{
	
	
	def getSession(){
		return SessionManager.getSession()
	}
	
	override def void persistir(Aerolinea unaAerolinea) {
		this.getSession().save(unaAerolinea)
	}
	
	override def void actualizar(Aerolinea unaAerolinea, String field, String unique_value) {
		this.getSession.update(unaAerolinea)
	}
	
	override def void borrar(String campo, String valor) {

		this.getSession().delete(this.traer(campo, valor))
	}
	
	override def Aerolinea traer(String field, String value) {

		//var aerolineas = this.getSession().createCriteria(Aerolinea).add(Restrictions.like(field, value)).list()
	 
		var stmt = "from Aerolinea as a where a." + field + " = " + value
		var query = this.getSession().createSQLQuery(stmt)
		var aerolineas = query.list() //as ArrayList<Aerolinea>
		var aerolinea = aerolineas.get(0) as Aerolinea
		return aerolinea
	
		//return this.getSession().get(typeof(Aerolinea), Integer.parseInt(value)) as Aerolinea 
	}

	override def boolean contiene(String field, String value) {
		return this.getSession().createQuery("from Aerolinea as a where a." + field + "=" + value).list().length() > 0
	}

	override valores(Aerolinea unaAerolinea){
		return new ArrayList<String>()
	}

	override campos() {
		new ArrayList<String>()
	}
	
	override objectNotFoundError() throws Exception {
		new AerolineaNoExisteException("no existe esta aerolinea")
	}

}
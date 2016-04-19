package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import ar.edu.unq.epers.aterrizar.exceptions.AerolineaNoExisteException
import java.util.ArrayList

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

	 
		var stmt = "from Aerolinea as a where a." + field + " = :" + field
		var query = this.getSession().createQuery(stmt)
		query.setParameter(field, value)
		var aerolineas = query.list() //as ArrayList<Aerolinea>
		if(aerolineas.isEmpty){
			return null
		}
		var aerolinea = aerolineas.get(0) as Aerolinea
		
		return aerolinea
	
	}

	override def boolean contiene(String field, String value) {
		traer(field, value) != null
	}

	override valores(Aerolinea unaAerolinea){
		return new ArrayList<String>()
	}

	override campos() {
		new ArrayList<String>()
	}
	
	override objectNotFoundError() throws Exception {
		new AerolineaNoExisteException("no existe esa aerolinea")
	}

}
package ar.edu.unq.epers.aterrizar.domain.buscador

import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import ar.edu.unq.epers.aterrizar.persistence.SessionManager

class CriterioPorOrigen extends Criterio{
	
	String origen
	
	new(String origen){
		this.origen = origen
	}
	
	override satisface(Aerolinea a) {
	
		return true	
	}
		
	override getCondicion() {

		var sesion = SessionManager.getSession()
		var query = sesion.createQuery("from Vuelo as vuelo join vuelo.tramos as tramos where tramos.origen = :origen")
		
		//query.setString("origen", origen)
		query.setParameter("origen", origen)
		
		var hql = query.queryString
		
		return hql
	}
	
	
	
}
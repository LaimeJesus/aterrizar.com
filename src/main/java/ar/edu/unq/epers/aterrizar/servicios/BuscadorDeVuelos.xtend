package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import java.util.List
import ar.edu.unq.epers.aterrizar.persistence.RepositorioBusquedas
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorCostoDeVuelo
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorEscalas
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorDuracion
import ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda

@Accessors
class BuscadorDeVuelos {
	
	RepositorioBusquedas repositorioDeBusquedas = new RepositorioBusquedas
	RepositorioAerolinea repositorioAerolineas
	
	new(){
		
	}
	
	new(RepositorioAerolinea repoAerolinea){
		repositorioAerolineas = repoAerolinea
	}

	
	def buscarVuelos(Busqueda b){
		var res = SessionManager.runInSession
		[|
			var sesion = repositorioAerolineas.getSession()
			var query = b.getQuery()
			var queryResultado = sesion.createQuery(query)
			
			queryResultado.list() as List<Vuelo>
			
		]
		guardar(b)
		return res
	}


//caso de uso ordenar una busqueda por algun orden
	def Busqueda ordenarPorMenorCosto(Busqueda b) {
		var menorCosto = new OrdenPorCostoDeVuelo
		menorCosto.porMenorOrden
		b.ordenarPor(menorCosto)
		return b
	}

//caso de uso ordenar una busqueda por algun orden
	def Busqueda ordenarPorMenorEscala(Busqueda b) {
		var menorTrayecto = new OrdenPorEscalas
		menorTrayecto.porMenorOrden

		b.ordenarPor(menorTrayecto)
		return b
	}

//caso de uso ordenar una busqueda por algun orden
	def Busqueda ordenarPorMenorDuracion(Busqueda b) {
		var menorDuracion = new OrdenPorDuracion
		menorDuracion.porMenorOrden

		b.ordenarPor(menorDuracion)
		return b
	}


//caso de uso conseguir la ultima busqueda ejecutada
	def Busqueda getUltimaBusqueda() {
		var resultado = SessionManager.runInSession(
			[
				repositorioDeBusquedas.traerUltimaBusqueda
			])
		return resultado
	}

//caso de uso guardar una busqueda para volver a utilizarla luego
	def void guardar(Busqueda b) {
		SessionManager.runInSession(
			[
				repositorioDeBusquedas.persistir(b)
				null
			])
	}
	def getBusquedas(){
		SessionManager.runInSession [| repositorioDeBusquedas.traerBusquedas ] 
	}

	def eliminarBusquedas() {
		
		val busquedas = getBusquedas()
		if(!busquedas.isEmpty){
		SessionManager.runInSession [|
			for(Busqueda busqueda : busquedas){
				repositorioDeBusquedas.borrar(busqueda)
			}
				
			null
		]
		}
	}

}
package ar.edu.unq.epers.aterrizar.servicios

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorCostoDeVuelo
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorEscalas
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorDuracion
import ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda
import ar.edu.unq.epers.aterrizar.persistence.hibernate.RepositorioBusquedas
import ar.edu.unq.epers.aterrizar.persistence.hibernate.RepositorioAerolinea
import ar.edu.unq.epers.aterrizar.persistence.hibernate.SessionManager
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorVueloReservado
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.domain.vuelos.Vuelo

@Accessors
class ServicioDeBusquedaDeVuelos {
	
	RepositorioBusquedas repositorioDeBusquedas
	RepositorioAerolinea repositorioAerolineas
	
	new(){
		repositorioDeBusquedas = new RepositorioBusquedas
	}
	
	new(RepositorioAerolinea repoAerolinea){
		repositorioDeBusquedas = new RepositorioBusquedas
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
	
	//caso de uso extra ver reservas realizadas por un usuario
	def verLugaresVisitados(Usuario u){
		var v = getVuelosReservados(u)
		val visitados = new ArrayList<String>()
		v.forEach[
			visitados.addAll(it.verDestinos())
		]
		visitados
	}
	def getVuelosReservados(Usuario u){
		var c = new CriterioPorVueloReservado(u)
		var b = new Busqueda(c)
		var vuelos = buscarVuelos(b)
		System.out.println(vuelos.length)
		vuelos
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
	
	def viajeA(Usuario usuario, String destino) {
		verLugaresVisitados(usuario).contains(destino)
	}

}

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
import ar.edu.unq.epers.aterrizar.domain.vuelos.Vuelo
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorDestino

@Accessors
class ServicioDeBusquedaDeVuelos {

	RepositorioBusquedas repositorioDeBusquedas
	RepositorioAerolinea repositorioAerolineas

	new() {
		setRepositorioDeBusquedas(new RepositorioBusquedas)
	}

	new(RepositorioAerolinea repoAerolinea) {
		setRepositorioDeBusquedas(new RepositorioBusquedas)
		setRepositorioAerolineas(repoAerolinea)
	}

	def buscarNormal(Busqueda b) {
		b.armarQueryNormal
		buscarVuelos(b)
	}

	def buscarPorUsuarios(Busqueda b) {
		b.armarQueryConUsuarios()
		buscarVuelos(b)
	}

	def buscarVuelos(Busqueda b) {
		var res = SessionManager.runInSession [|
			var sesion = getRepositorioAerolineas.getSession()
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
				getRepositorioDeBusquedas.traerUltimaBusqueda
			])
		return resultado
	}

	//caso de uso guardar una busqueda para volver a utilizarla luego
	def void guardar(Busqueda b) {
		SessionManager.runInSession(
			[
				getRepositorioDeBusquedas.persistir(b)
				null
			])
	}

	def getBusquedas() {
		SessionManager.runInSession[|getRepositorioDeBusquedas.traerBusquedas]
	}

	def eliminarBusquedas() {

		val busquedas = getBusquedas()
		if(!busquedas.isEmpty) {
			SessionManager.runInSession [|
				for (Busqueda busqueda : busquedas) {
					getRepositorioDeBusquedas.borrar(busqueda)
				}
				null
			]
		}
	}

	def viajeA(Usuario usuario, String destino) {

		var busqueda = getBusquedaDestinosVisitados(usuario, destino)
		var vuelos = buscarPorUsuarios(busqueda)

		vuelos.length > 0
	}

	def getBusquedaVuelosReservados(Usuario u) {
		var asientosReservados = new CriterioPorVueloReservado(u)
		var b = new Busqueda(asientosReservados)
		b
	}
	def getBusquedaDestinosVisitados(Usuario u, String destino){
		var asientosReservados = new CriterioPorVueloReservado(u)
		var destinos = new CriterioPorDestino(destino)
		var condicion = asientosReservados.and(destinos)
		var b = new Busqueda(condicion)
		b
		
	}

}

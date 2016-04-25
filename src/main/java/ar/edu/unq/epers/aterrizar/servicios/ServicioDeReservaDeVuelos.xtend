package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import ar.edu.unq.epers.aterrizar.domain.Tramo
import ar.edu.unq.epers.aterrizar.domain.Asiento
import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import java.util.List
import ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda
import ar.edu.unq.epers.aterrizar.domain.buscador.BuscadorDeVuelos
import ar.edu.unq.epers.aterrizar.persistence.RepositorioBusquedas
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorCostoDeVuelo
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorEscalas
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorDuracion
import ar.edu.unq.epers.aterrizar.exceptions.ReservarException
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ServicioDeReservaDeVuelos {

	//Nuestro sistema de reserva de asientos
	RepositorioAerolinea repositorioDeAerolineas
	BuscadorDeVuelos buscador
	RepositorioBusquedas repositorioDeBusquedas

	new() {
		repositorioDeAerolineas = new RepositorioAerolinea
		buscador = new BuscadorDeVuelos(repositorioDeAerolineas)
		repositorioDeBusquedas = new RepositorioBusquedas

	}

	def Asiento reservar(Usuario usuario, Aerolinea unaAerolinea, Vuelo unVuelo, Tramo unTramo, Asiento unAsiento) {

		var aerolineaFromRepo = this.traerAerolinea(unaAerolinea)
		var vuelos = aerolineaFromRepo.vuelos

		//no estoy seguro pero creo que esto funcionaria asi
		if(vuelos.exists[Vuelo v|v.nroVuelo == unVuelo.nroVuelo]) {
			var tramos = unVuelo.tramos
			if(tramos.exists[Tramo t|t.nroTramo == unTramo.nroTramo]) {
				var asientos = unTramo.asientos
				if(asientos.exists[Asiento a|a.nroAsiento == unAsiento.nroAsiento]) {
					var asientoAReservar = asientos.get(asientos.indexOf(unAsiento))
					if(!asientoAReservar.reservado) {
						return this.reservarAsiento(aerolineaFromRepo, unVuelo, unTramo, asientoAReservar, usuario)
					} else {
						throw new ReservarException("asiento reservado")
					}
				} else {
					throw new ReservarException("asiento no pertenece a ese tramo")
				}
			} else {
				throw new ReservarException("ese tramo no pertenece a ese vuelo")
			}
		} else {
			throw new ReservarException("ese vuelo no pertenece a esa aerolinea")
		}
	}

	def reservarAsiento(Aerolinea aerolinea, Vuelo vuelo, Tramo tramo, Asiento asiento, Usuario usuario) {

		aerolinea.removerVuelo(vuelo)
		vuelo.removerTramo(tramo)
		tramo.removerAsiento(asiento)

		asiento.reservar(usuario)
		tramo.agregarAsiento(asiento)
		vuelo.agregarTramo(tramo)
		aerolinea.agregarVuelo(vuelo)

		this.actualizarAerolinea(aerolinea)

		return asiento
	}

	def List<Vuelo> buscar(Busqueda b) {

		var resultado = buscador.buscarVuelos(b)
		guardar(b)

		return resultado
	}

	def List<Asiento> consultarAsientos(Tramo t) {
		return t.asientosDisponibles
	}

	def Busqueda getUltimaBusqueda() {
		var resultado = SessionManager.runInSession(
			[
				repositorioDeBusquedas.traerPorId
			])
		return resultado
	}

	def void guardar(Busqueda b) {
		SessionManager.runInSession(
			[
				repositorioDeBusquedas.persistir(b)
				null
			])
	}

	def Busqueda ordenarPorMenorCosto(Busqueda b) {
		var menorCosto = new OrdenPorCostoDeVuelo
		menorCosto.porMenorOrden
		b.ordenarPor(menorCosto)
		return b
	}

	def Busqueda ordenarPorMenorEscala(Busqueda b) {
		var menorTrayecto = new OrdenPorEscalas
		menorTrayecto.porMenorOrden

		b.ordenarPor(menorTrayecto)
		return b
	}

	def Busqueda ordenarPorMenorDuracion(Busqueda b) {
		var menorDuracion = new OrdenPorDuracion
		menorDuracion.porMenorOrden

		b.ordenarPor(menorDuracion)
		return b
	}

	def actualizarReservas(Aerolinea aerolinea, Asiento asiento, Usuario usuario) {

		this.actualizarAerolinea(aerolinea)
	}

	def actualizarAerolinea(Aerolinea aerolinea) {
		SessionManager.runInSession(
			[
				repositorioDeAerolineas.actualizar(aerolinea, "nombreAerolinea", aerolinea.nombreAerolinea)
				null
			])
	}

	def Aerolinea traerAerolinea(Aerolinea unaAerolinea) {

		var resultado = SessionManager.runInSession(
			[
				repositorioDeAerolineas.traer("nombreAerolinea", unaAerolinea.nombreAerolinea)
			])
		return resultado
	}

	def eliminarAerolinea(Aerolinea unaAero) {
		SessionManager.runInSession [|
			repositorioDeAerolineas.borrar("nombreAerolinea", unaAero.nombreAerolinea)
			null
		]
	}

	def agregarAerolinea(Aerolinea aerolinea) {
		SessionManager.runInSession [|
			repositorioDeAerolineas.persistir(aerolinea)
			null
		]
	}

	def existeAeroliena(Aerolinea aerolinea) {
		return SessionManager.runInSession [|
			repositorioDeAerolineas.contiene("nombreAerolinea", aerolinea.nombreAerolinea)
		]

	}
	
	def getBusquedas(){
		SessionManager.runInSession [| repositorioDeBusquedas.traerBusquedas ] 
	}

	def eliminarBusquedas() {
		val busquedas = busquedas
		SessionManager.runInSession [|
			for(Busqueda busqueda: busquedas){
				var id = String.valueOf(busqueda.idBusqueda)
				repositorioDeBusquedas.borrar("idBusqueda", id)
			}
				
			null
		]
	}
}

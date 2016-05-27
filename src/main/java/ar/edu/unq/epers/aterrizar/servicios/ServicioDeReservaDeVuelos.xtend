package ar.edu.unq.epers.aterrizar.servicios

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.hibernate.RepositorioAerolinea
import ar.edu.unq.epers.aterrizar.persistence.hibernate.SessionManager
import ar.edu.unq.epers.aterrizar.domain.vuelos.Asiento
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.vuelos.Aerolinea
import ar.edu.unq.epers.aterrizar.domain.vuelos.Vuelo
import ar.edu.unq.epers.aterrizar.domain.vuelos.Tramo

@Accessors
class ServicioDeReservaDeVuelos {

	//Nuestro sistema de reserva de asientos
	RepositorioAerolinea repositorioDeAerolineas

	new() {
		repositorioDeAerolineas = new RepositorioAerolinea
	}

	//caso de uso un usuario quiere reservar un asiento de un tramo de un vuelo de una Aerolinea
	def Asiento reservar(Usuario usuario, Aerolinea unaAerolinea, Vuelo unVuelo, Tramo unTramo, Asiento unAsiento) {

		//no entiendo xq pero no me deja usar estos tres metodos para realizar la reserva. asi que lo hago todo en una session
		//		var aerolineaFromRepo = traerAerolinea(unaAerolinea)
		//		aerolineaFromRepo.validarReserva(unVuelo, unTramo, unAsiento)
		//		reservarAsiento(aerolineaFromRepo, unAsiento, usuario)
		SessionManager.runInSession [|
			val session = SessionManager.getSession()
			session.saveOrUpdate(usuario)
			val aero = repositorioDeAerolineas.traer("nombreAerolinea", unaAerolinea.nombreAerolinea)
			aero.validarReserva(unVuelo, unTramo, unAsiento)
			unAsiento.reservar(usuario)
			repositorioDeAerolineas.actualizar(aero)
			null
		]
		unAsiento
	}

	//caso de uso que tal vez no deberia estar
	def List<Asiento> consultarAsientos(Tramo t) {
		return t.asientosDisponibles
	}

	/////////////////////////////////////////////////
	def reservarAsiento(Aerolinea aerolinea, Asiento asiento, Usuario usuario) {

		asiento.reservar(usuario)

		this.actualizarAerolinea(aerolinea)

		return asiento
	}

	def actualizarAerolinea(Aerolinea unaAerolinea) {
		SessionManager.runInSession(
			[
				repositorioDeAerolineas.actualizar(unaAerolinea)
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

	def eliminarAerolinea(Aerolinea unaAerolinea) {
		SessionManager.runInSession [|
			repositorioDeAerolineas.borrar(unaAerolinea)
			null
		]
	}

	def agregarAerolinea(Aerolinea aerolinea) {
		SessionManager.runInSession [|
			repositorioDeAerolineas.persistir(aerolinea)
			null
		]
	}

	def existeAerolinea(Aerolinea aerolinea) {
		return SessionManager.runInSession [|
			repositorioDeAerolineas.contiene("nombreAerolinea", aerolinea.nombreAerolinea)
		]

	}
}

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
import ar.edu.unq.epers.aterrizar.exceptions.AerolineaNoExisteException

@Accessors
class ServicioDeReservaDeVuelos {

	//Nuestro sistema de reserva de asientos
	RepositorioAerolinea repositorioDeAerolineas
	ServicioDeRegistroDeUsuarios servicioDeRegistroDeUsuarios

	new() {
		repositorioDeAerolineas = new RepositorioAerolinea
	}
	new(ServicioDeRegistroDeUsuarios sru){
		servicioDeRegistroDeUsuarios = sru
		repositorioDeAerolineas = new RepositorioAerolinea
	}
	//caso de uso un usuario quiere reservar un asiento de un tramo de un vuelo de una Aerolinea
	def Asiento reservar(Usuario usuario, Aerolinea unaAerolinea, Vuelo unVuelo, Tramo unTramo, Asiento unAsiento) throws Exception{

		//no entiendo xq pero no me deja usar estos tres metodos para realizar la reserva. asi que lo hago todo en una session
		
		servicioDeRegistroDeUsuarios.isRegistrado(usuario)
		isRegistrado(unaAerolinea)
		var aero = traerAerolinea(unaAerolinea)
		aero.validarReserva(unVuelo, unTramo, unAsiento)
		reservarAsiento(aero, unAsiento, usuario)
		actualizarAerolinea(aero)
		unAsiento
	}
	
	def isRegistrado(Aerolinea aerolinea) throws AerolineaNoExisteException{
		if(!existeAerolinea(aerolinea)){
			throw new AerolineaNoExisteException("No existe " + aerolinea.nombreAerolinea)
		}
	}

	//caso de uso que tal vez no deberia estar
	def List<Asiento> consultarAsientos(Tramo t) {
		return t.asientosDisponibles
	}

	/////////////////////////////////////////////////
	def Asiento reservarAsiento(Aerolinea aerolinea, Asiento asiento, Usuario usuario) {

		asiento.reservar(usuario)

		this.actualizarAerolinea(aerolinea)

		return asiento
	}

	def void actualizarAerolinea(Aerolinea unaAerolinea) {
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

	def void eliminarAerolinea(Aerolinea unaAerolinea) {
		SessionManager.runInSession [|
			repositorioDeAerolineas.borrar(unaAerolinea)
			null
		]
	}

	def void agregarAerolinea(Aerolinea aerolinea) {
		SessionManager.runInSession [|
			repositorioDeAerolineas.persistir(aerolinea)
			null
		]
	}

	def boolean existeAerolinea(Aerolinea aerolinea) {
		return SessionManager.runInSession [|
			repositorioDeAerolineas.contiene("nombreAerolinea", aerolinea.nombreAerolinea)
		]

	}
}

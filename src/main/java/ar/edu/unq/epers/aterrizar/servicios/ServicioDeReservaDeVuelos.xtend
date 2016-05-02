package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import ar.edu.unq.epers.aterrizar.domain.Asiento
import ar.edu.unq.epers.aterrizar.domain.Tramo
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import ar.edu.unq.epers.aterrizar.domain.buscador.BuscadorDeVuelos
import ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda
import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import ar.edu.unq.epers.aterrizar.persistence.RepositorioBusquedas
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import java.util.List
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


	//caso de uso un usuario quiere reservar un asiento de un tramo de un vuelo de una Aerolinea
	def Asiento reservar(Usuario usuario, Aerolinea unaAerolinea, Vuelo unVuelo, Tramo unTramo, Asiento unAsiento) {

		var aerolineaFromRepo = traerAerolinea(unaAerolinea)
		
					System.out.println(aerolineaFromRepo.nombreAerolinea)
		aerolineaFromRepo.vuelos.forEach[
					System.out.println(it.nroVuelo)			
		]

		aerolineaFromRepo.validarReserva(unVuelo, unTramo, unAsiento)
		
		reservarAsiento(aerolineaFromRepo, unAsiento, usuario)
		// el param unAsiento es el asiento que va reservar?		
	}

//caso de uso: un usuario quiere buscar vuelos por un criterio y algun orden
	def List<Vuelo> buscar(Busqueda b) {

		var resultado = buscador.buscarVuelos(b)

		return resultado
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

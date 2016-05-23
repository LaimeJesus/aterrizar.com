package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.Test
import ar.edu.unq.epers.aterrizar.servicios.ServicioDePerfiles
import ar.edu.unq.epers.aterrizar.servicios.ServicioRegistroUsuarioConHibernate
import ar.edu.unq.epers.aterrizar.domain.Usuario
import org.junit.Assert
import org.junit.After
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeReservaDeVuelos

class ServicioDePerfilesTest {

	ServicioRegistroUsuarioConHibernate userService

	ServicioDePerfiles sut

	Usuario pepe

	Usuario jose
	
	ServicioDeReservaDeVuelos flightService

	@Before
	def void setUp() {
		
		flightService = new ServicioDeReservaDeVuelos()
		
		pepe = new Usuario()
		pepe.nickname = "pepe"

		jose = new Usuario()
		jose.nickname = "jose"

		userService = new ServicioRegistroUsuarioConHibernate()
		userService.registrarUsuario(pepe)
		sut = userService.servicioDePerfiles
		sut.servicioDeBusqueda.repositorioAerolineas = flightService.repositorioDeAerolineas
	}

	@Test
	def void testUnUsuarioRegistradoTieneUnPerfilSinNada() {
		//
		var perfilPepe = sut.getPerfil(pepe)
		System.out.println()
		Assert.assertTrue(perfilPepe.nickname.equals("pepe"))
	}

	@After
	def void borrarDatosCreadosEnSetUp() {
		userService.eliminarUsuario(pepe)
		sut.eliminarTodosLosPerfiles
	}
}

package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.Test
import ar.edu.unq.epers.aterrizar.servicios.ServicioDePerfiles
import ar.edu.unq.epers.aterrizar.servicios.ServicioRegistroUsuarioConHibernate
import ar.edu.unq.epers.aterrizar.domain.Usuario
import org.junit.Assert

class ServicioDePerfilesTest {

	ServicioRegistroUsuarioConHibernate userService

	ServicioDePerfiles sut

	Usuario pepe

	Usuario jose

	@Before
	def void setUp() {
		pepe = new Usuario()
		pepe.nickname = "pepe"

		jose = new Usuario()
		jose.nickname = "jose"

		userService = new ServicioRegistroUsuarioConHibernate()
		userService.registrarUsuario(pepe)
		sut = userService.servicioDePerfiles
	}

	@Test
	def void testUnUsuarioRegistradoTieneUnPerfilSinNada() {
		//
		var perfilPepe = sut.getPerfil(pepe)
		
		Assert.assertTrue(perfilPepe.nickname.equals("pepe"))
	}

	@Test
	def void borrarDatosCreadosEnSetUp() {
		userService.eliminarUsuario(pepe)
	}
}

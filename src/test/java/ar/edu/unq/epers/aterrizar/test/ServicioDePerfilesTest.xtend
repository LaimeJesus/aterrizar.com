package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.Test
import ar.edu.unq.epers.aterrizar.servicios.ServicioDePerfiles
import ar.edu.unq.epers.aterrizar.servicios.ServicioRegistroUsuarioConHibernate
import ar.edu.unq.epers.aterrizar.domain.Usuario
import org.junit.Assert
import org.junit.After
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeReservaDeVuelos
import ar.edu.unq.epers.aterrizar.exceptions.NoPuedeAgregarPostException
import ar.edu.unq.epers.aterrizar.domain.DestinoPost
import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import ar.edu.unq.epers.aterrizar.domain.Tramo
import ar.edu.unq.epers.aterrizar.domain.Asiento
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria

class ServicioDePerfilesTest {

	ServicioRegistroUsuarioConHibernate userService

	ServicioDePerfiles sut

	Usuario pepe

	ServicioDeReservaDeVuelos flightService

	Aerolinea aa

	Vuelo v1

	Tramo argentinabrasil

	Asiento asientolibre

	@Before
	def void setUp() {

		flightService = new ServicioDeReservaDeVuelos()

		pepe = new Usuario()
		pepe.nickname = "pepe"

		userService = new ServicioRegistroUsuarioConHibernate()
		userService.registrarUsuario(pepe)
		sut = userService.servicioDePerfiles
		sut.servicioDeBusqueda.repositorioAerolineas = flightService.repositorioDeAerolineas

		aa = new Aerolinea("AerolineasArgentinas")

		v1 = new Vuelo(1)
		aa.agregarVuelo(v1)
		argentinabrasil = new Tramo("Argentina", "Brasil", 100, "2016-5-10", "2016-5-11", 1)
		v1.agregarTramo(argentinabrasil)
		asientolibre = new Asiento(TipoDeCategoria.PRIMERA, 50, 1)
		argentinabrasil.agregarAsiento(asientolibre)
		flightService.agregarAerolinea(aa)
		flightService.reservar(pepe, aa, v1, argentinabrasil, asientolibre)

	}

	@Test
	def void testUnUsuarioRegistradoTieneUnPerfilSinNada() {

		//
		var perfilPepe = sut.getPerfil(pepe)
		Assert.assertTrue(perfilPepe.nickname.equals("pepe"))
	}

	@Test(expected=NoPuedeAgregarPostException)
	def void testCrearUnDestinoPostDeUnLugarQueNoFuiTiraUnaExcepcion() {
		var post = new DestinoPost("lugar desconocido")
		sut.agregarPost(pepe, post)
	}

	@Test
	def void testCrearUnDestinoPostDeUnLugarQueFuiMeAgregaUnPost() {

		var post = new DestinoPost("Brasil")
		sut.agregarPost(pepe, post)
	}

	@After
	def void borrarDatosCreadosEnSetUp() {
		
	//	userService.eliminarUsuario(pepe)
	}
}

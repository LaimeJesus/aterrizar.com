package ar.edu.unq.epers.aterrizar.test

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.redsocial.DestinoPost
import ar.edu.unq.epers.aterrizar.servicios.ServicioDePerfiles
import ar.edu.unq.epers.aterrizar.servicios.ServicioRegistroUsuarioConHibernate
import org.junit.Assert
import org.junit.After
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria
import org.junit.Before
import org.junit.Test
import ar.edu.unq.epers.aterrizar.domain.vuelos.Asiento
import ar.edu.unq.epers.aterrizar.domain.vuelos.Tramo
import ar.edu.unq.epers.aterrizar.domain.vuelos.Vuelo
import ar.edu.unq.epers.aterrizar.domain.vuelos.Aerolinea
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeReservaDeVuelos
import ar.edu.unq.epers.aterrizar.domain.redsocial.Comment
import ar.edu.unq.epers.aterrizar.exceptions.NoExistePostException
import ar.edu.unq.epers.aterrizar.exceptions.NoPuedesVotarException

class ServicioDePerfilesTest {

	ServicioRegistroUsuarioConHibernate userService

	ServicioDePerfiles sut

	Usuario pepe

	ServicioDeReservaDeVuelos flightService

	Aerolinea aa

	Vuelo v1

	Tramo argentinabrasil

	Asiento asientolibre

	Asiento nuevoAsiento

	DestinoPost postBrazil

	Comment commentForPostBrazil

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
		argentinabrasil = new Tramo("Argentina", "Brazil", 100, "2016-5-10", "2016-5-11", 1)
		v1.agregarTramo(argentinabrasil)
		asientolibre = new Asiento(TipoDeCategoria.PRIMERA, 50, 1)
		argentinabrasil.agregarAsiento(asientolibre)
		flightService.agregarAerolinea(aa)

		nuevoAsiento = flightService.reservar(pepe, aa, v1, argentinabrasil, asientolibre)
		postBrazil = new DestinoPost("1", "Brazil")
		sut.agregarPost(pepe, postBrazil)
		commentForPostBrazil = new Comment("1", "BEST TRIP EVER")

		sut.comentarPost(pepe, postBrazil, commentForPostBrazil)
		sut.meGusta(pepe, postBrazil)

	}

	@Test
	def void testUnUsuarioRegistradoTieneUnPerfilSinNada() {

		var perfilPepe = sut.getPerfil(pepe)
		Assert.assertTrue(perfilPepe.nickname.equals("pepe"))
	}

	//al no poder chequear los vuelos este test no funciona, por el momento
	//	@Test(expected=NoPuedeAgregarPostException)
	//	def void testCrearUnDestinoPostDeUnLugarQueNoFuiTiraUnaExcepcion() {
	//		var post = new DestinoPost("1", "lugar desconocido")
	//		sut.agregarPost(pepe, post)
	//	}
	//asiento no guarda el id del usuario que reserva el vuelo asi que no puedo ver los vuelos reservados por un usuario
	@Test
	def void testCrearUnDestinoPostDeUnLugarQueFuiMeAgregaUnPost() {

		var p = sut.getPerfil(pepe)
		Assert.assertEquals(1, p.posts.length)
	}

	@Test
	def void testAgregarUnComentarioAUnPost() {

		var p = sut.getPerfil(pepe)
		Assert.assertEquals(1, p.getComments(postBrazil).length)
	}

	@Test(expected=NoExistePostException)
	def void testAgregarUnComentarioAUnPostQueNoExisteArrojaUnaExcepcion() {
		var noExistePost = new DestinoPost("2", "UGANDA")
		var com = new Comment("2", "HOLA")
		sut.comentarPost(pepe, noExistePost, com)

	}

	@Test
	def void testAgregarMeGustaAUnPostAumentaLaCantidadDeLikesEnUno() {

		System.out.println(postBrazil)
		var p = sut.getPerfil(pepe)
		var cantidadDeMegusta = p.cantidadDeMeGusta(postBrazil)
		Assert.assertEquals(1, cantidadDeMegusta)
	}

	@Test(expected=NoPuedesVotarException)
	def void testAgregarMeGustaAUnPostQueYaLikeeArrojaUnaExceptcion() {
		sut.meGusta(pepe, postBrazil)
	}

	@After
	def void borrarDatosCreadosEnSetUp() {

		flightService.eliminarAerolinea(aa)
		userService.borrarDeAmigos(pepe)
		userService.borrarDePerfiles(pepe)
		sut.repositorioDePerfiles.deleteAll

	}
}

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
import ar.edu.unq.epers.aterrizar.domain.redsocial.visibility.Visibility
import ar.edu.unq.epers.aterrizar.exceptions.NoPuedeAgregarPostException

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

	Usuario jose

	@Before
	def void setUp() {



		/////////////////////////////////////////////////////////
		//registrar usuario
		/////////////////////////////////////////////////////////
		pepe = new Usuario()
		pepe.nickname = "pepe"
		jose = new Usuario()
		jose.nickname = "jose"

		userService = new ServicioRegistroUsuarioConHibernate()
		userService.registrarUsuario(pepe)
		userService.registrarUsuario(jose)

		/////////////////////////////////////////////////////////
		//iniciando sut
		/////////////////////////////////////////////////////////
		sut = userService.servicioDePerfiles
		flightService = new ServicioDeReservaDeVuelos(userService)
		sut.servicioDeBusqueda.repositorioAerolineas = flightService.repositorioDeAerolineas

		/////////////////////////////////////////////////////////
		//aerolinea para reservar un asiento
		/////////////////////////////////////////////////////////
		aa = new Aerolinea("AerolineasArgentinas")

		v1 = new Vuelo(1)
		aa.agregarVuelo(v1)
		argentinabrasil = new Tramo("Argentina", "Brazil", 100, "2016-5-10", "2016-5-11", 1)
		v1.agregarTramo(argentinabrasil)
		asientolibre = new Asiento(TipoDeCategoria.PRIMERA, 50, 1)
		argentinabrasil.agregarAsiento(asientolibre)
		flightService.agregarAerolinea(aa)

		nuevoAsiento = flightService.reservar(pepe, aa, v1, argentinabrasil, asientolibre)

		/////////////////////////////////////////////////////////
		//perfiles
		/////////////////////////////////////////////////////////
		postBrazil = new DestinoPost("1", "Brazil")
		sut.agregarPost(pepe, postBrazil)

		commentForPostBrazil = new Comment("1", "BEST TRIP EVER")

		sut.comentarPost(pepe, postBrazil, commentForPostBrazil)
		sut.meGusta(pepe, pepe, postBrazil)
		sut.noMeGusta(pepe, jose, postBrazil)
		sut.meGusta(pepe, pepe, postBrazil, commentForPostBrazil)
		sut.noMeGusta(pepe, jose, postBrazil, commentForPostBrazil)
	}

	@Test
	def void testUnUsuarioRegistradoTieneUnPerfilSinNada() {

		var perfilPepe = sut.getPerfil(pepe)
		Assert.assertTrue(perfilPepe.nickname.equals("pepe"))
	}

	//	al no poder chequear los vuelos este test no funciona, por el momento
//	@Test(expected=NoPuedeAgregarPostException)
//	def void testCrearUnDestinoPostDeUnLugarQueNoFuiTiraUnaExcepcion() {
//		var post = new DestinoPost("1", "lugar desconocido")
//		sut.agregarPost(pepe, post)
//	}

	//asiento no guarda el id del usuario que reserva el vuelo asi que no puedo ver los vuelos reservados por un usuario
	////////////////////////////////////////////////////////
	//postear y comentar
	////////////////////////////////////////////////////////
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

	////////////////////////////////////////////////////////
	//agregar me gusta y no me gusta a posts y cometnarios
	////////////////////////////////////////////////////////
	@Test
	def void testAgregarMeGustaAUnPostAumentaLaCantidadDeMeGustaEnUno() {

		var p = sut.getPerfil(pepe)
		var cantidadDeMegusta = p.cantidadDeMeGusta(postBrazil)
		Assert.assertEquals(1, cantidadDeMegusta)
	}

	@Test(expected=NoPuedesVotarException)
	def void testAgregarMeGustaAUnPostQueYaLikeeArrojaUnaExceptcion() {
		sut.meGusta(pepe, pepe, postBrazil)
	}

	@Test(expected=NoPuedesVotarException)
	def void testAgregarNoMeGustaAUnPostQueYaLePuseMeGustaArrojaUnaExcepcion() {

		sut.noMeGusta(pepe, pepe, postBrazil)
	}

	@Test
	def void testAgregarNoMeGustaAUnPostAumentaLaCantidadDeNoMeGustaEnUno() {
		var p = sut.getPerfil(pepe)
		var cantidadDeNoMeGusta = p.cantidadDeNoMeGusta(postBrazil)
		Assert.assertEquals(1, cantidadDeNoMeGusta)
	}

	@Test(expected=NoPuedesVotarException)
	def void testAgregarNoMeGustaAUnPostQueYaLikeeArrojaUnaExceptcion() {
		sut.noMeGusta(pepe, jose, postBrazil)
	}

	@Test(expected=NoPuedesVotarException)
	def void testAgregarMeGustaAUnPostQueYaLePuseNoMeGustaArrojaUnaExcepcion() {

		sut.meGusta(pepe, jose, postBrazil)
	}

	@Test
	def void testAgregarMeGustaAUnComentarioSumaSuCantidadEnUno() {

		var perfilPepe = sut.getPerfil(pepe)
		var cantidad = perfilPepe.cantidadDeMeGusta(postBrazil, commentForPostBrazil)
		Assert.assertEquals(1, cantidad)
	}

	@Test
	def void testAgregarNoMeGustaAUnComentarioSumaSuCantidadEnUno() {

		var perfilPepe = sut.getPerfil(pepe)
		var cantidad = perfilPepe.cantidadDeNoMeGusta(postBrazil, commentForPostBrazil)
		Assert.assertEquals(1, cantidad)

	}

	////////////////////////////////////////////////////////
	//configurar perfil
	////////////////////////////////////////////////////////
	@Test
	def void testCambiarPostAPublicDejaQueCualquieraVeaEsePost() {
		sut.cambiarAPublico(pepe, postBrazil)
		var perfilPepe = sut.verPerfil(pepe, jose)

		Assert.assertEquals(Visibility.PUBLIC, perfilPepe.getPost(postBrazil).visibility)
		Assert.assertTrue(perfilPepe.getPost(postBrazil).destino == "Brazil")
	}

	@Test(expected=NoExistePostException)
	def void testNoPuedoVerUnPostPrivadoDeUnPerfil() {
		sut.cambiarAPrivado(pepe, postBrazil)
		var perfilPepe = sut.verPerfil(pepe, jose)
		Assert.assertEquals(Visibility.PRIVATE, perfilPepe.getPost(postBrazil).visibility)
	}

	@Test
	def void testCambiarPostAPrivateDejaQueSoloYoVeaEsePost() {
		sut.cambiarAPrivado(pepe, postBrazil)
		var perfilPepe = sut.verPerfil(pepe, pepe)
		Assert.assertEquals(Visibility.PRIVATE, perfilPepe.getPost(postBrazil).visibility)
	}

	@Test
	def void testCambiarPostAJustFriendDejaQueSoloMisAmigosVeanEsePost() {
		sut.cambiarASoloAmigos(pepe, postBrazil)
		var perfilPepe = sut.verPerfil(pepe, jose)
		Assert.assertEquals(Visibility.JUSTFRIENDS, perfilPepe.getPost(postBrazil).visibility)
	}

	@After
	def void borrarDatosCreadosEnSetUp() {

		flightService.eliminarAerolinea(aa)
		userService.borrarDeAmigos(pepe)
		userService.borrarDePerfiles(pepe)
		userService.eliminarUsuario(jose)
		sut.repositorioDePerfiles.deleteAll
		sut.servicioDeBusqueda.eliminarBusquedas
	}
}

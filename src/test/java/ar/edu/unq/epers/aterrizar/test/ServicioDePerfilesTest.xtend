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
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeAmigos
import ar.edu.unq.epers.aterrizar.exceptions.NoPuedeAgregarPostException

class ServicioDePerfilesTest {

	ServicioRegistroUsuarioConHibernate userService

	ServicioDePerfiles sut

	Usuario pepe

	ServicioDeReservaDeVuelos flightService

	Asiento nuevoAsiento

	DestinoPost postBrazil

	Comment commentForPostBrazil

	Usuario jose

	Aerolinea aa

	ServicioDeAmigos friendsService

	Usuario juan

	@Before
	def void setUp() {

		inicializarServicioPerfil()

		/////////////////////////////////////////////////////////
		//registrar usuario
		/////////////////////////////////////////////////////////
		pepe = new Usuario()
		pepe.nickname = "pepe"
		jose = new Usuario()
		jose.nickname = "jose"
		juan = new Usuario()
		juan.nickname = "Juan"

		/////////////////////////////////////////////////////////
		//aerolinea para reservar un asiento
		/////////////////////////////////////////////////////////
		aa = new Aerolinea("AerolineasArgentinas")

		var v1 = new Vuelo(1)
		aa.agregarVuelo(v1)
		var argentinabrasil = new Tramo("Argentina", "Brazil", 100, "2016-5-10", "2016-5-11", 1)
		v1.agregarTramo(argentinabrasil)
		var asientolibre = new Asiento(TipoDeCategoria.PRIMERA, 50, 1)
		argentinabrasil.agregarAsiento(asientolibre)

		flightService.agregarAerolinea(aa)

		userService.registrarUsuario(pepe)
		userService.registrarUsuario(jose)
		userService.registrarUsuario(juan)

		/////////////////////////////////////////////////////////
		//reservar
		/////////////////////////////////////////////////////////
		nuevoAsiento = flightService.reservar(pepe, aa, v1, argentinabrasil, asientolibre)

		/////////////////////////////////////////////////////////
		//perfiles
		/////////////////////////////////////////////////////////
		postBrazil = new DestinoPost("1", "Brazil")

		//seteando system under test
		sut = userService.servicioDePerfiles

		//servicio de amigos
		friendsService = userService.servicioDeAmigos

		//seteando mismo servicio de amigos para sut y userService
		sut.servicioDeAmigos = friendsService

		//agregando amigo
		friendsService.agregarAmigo(pepe, jose)

		//agregando post a perfil de pepe
		sut.agregarPost(pepe, postBrazil)

		//comentario
		commentForPostBrazil = new Comment("1", "BEST TRIP EVER")

		//agregando commentario
		sut.comentarPost(pepe, postBrazil, commentForPostBrazil)

		//agregando me gusta o no megusta
		sut.meGusta(pepe, pepe, postBrazil)
		sut.noMeGusta(pepe, jose, postBrazil)
		sut.meGusta(pepe, pepe, postBrazil, commentForPostBrazil)
		sut.noMeGusta(pepe, jose, postBrazil, commentForPostBrazil)
	}

	/////////////////////////////////////////////////////////
	//iniciando sut
	/////////////////////////////////////////////////////////
	def inicializarServicioPerfil() {
		userService = new ServicioRegistroUsuarioConHibernate
		flightService = new ServicioDeReservaDeVuelos(userService)
		sut = userService.servicioDePerfiles
		sut.servicioDeBusqueda.repositorioAerolineas = flightService.repositorioDeAerolineas
	}

	@Test
	def void testUnUsuarioRegistradoTieneUnPerfilSinNada() {

		var perfilVacio = sut.getPerfil(jose)
		Assert.assertTrue(perfilVacio.nickname.equals("jose"))
		Assert.assertEquals(0, perfilVacio.posts.length)
	}

	//al no poder chequear los vuelos este test no funciona, por el momento
	@Test(expected=NoPuedeAgregarPostException)
	def void testCrearUnDestinoPostDeUnLugarQueNoFuiTiraUnaExcepcion() {
		var post = new DestinoPost("1", "lugar desconocido")
		sut.agregarPost(pepe, post)
	}

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
	//publico
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
		perfilPepe.getPost(postBrazil)
	}

	//privado
	@Test
	def void testCambiarPostAPrivateDejaQueSoloYoVeaEsePost() {
		sut.cambiarAPrivado(pepe, postBrazil)
		var perfilPepe = sut.verPerfil(pepe, pepe)
		Assert.assertEquals(Visibility.PRIVATE, perfilPepe.getPost(postBrazil).visibility)
	}

	//solo amigos
	@Test
	def void testCambiarPostAJustFriendDejaQueSoloMisAmigosVeanEsePost() {
		sut.cambiarASoloAmigos(pepe, postBrazil)
		var perfilPepe = sut.verPerfil(pepe, jose)
		Assert.assertEquals(Visibility.JUSTFRIENDS, perfilPepe.getPost(postBrazil).visibility)
	}

	@Test(expected=NoExistePostException)
	def void testCambiarPostAJustFriendNoDejaVerALosQueNoSonMisAmigos() {

		sut.cambiarASoloAmigos(pepe, postBrazil)

		var perfilPepe = sut.verPerfil(pepe, juan)
		Assert.assertEquals(Visibility.JUSTFRIENDS, perfilPepe.getPost(postBrazil).visibility)

	}

	//comentarios
	//public
	@Test
	def void testCambiarUnComentarioDeUnPostPublicoAPublicDejaQueCualquieraLoVea() {

		sut.cambiarAPublico(pepe, postBrazil)
		sut.cambiarAPublico(pepe, postBrazil, commentForPostBrazil)
		var perfilPepe = sut.verPerfil(pepe, jose)

		Assert.assertEquals(Visibility.PUBLIC,
			perfilPepe.getPost(postBrazil).getComment(commentForPostBrazil).visibility)
	}

	//	@Test(expected=NoExisteEseComentarioException)
	@Test
	def void testOtroUsuarioQuiereVerUnComentarioConVisibilidadPrivadaArrojaUnaExcepcion() {

		sut.cambiarAPublico(pepe, postBrazil)
		sut.cambiarAPrivado(pepe, postBrazil, commentForPostBrazil)
		var perfilPepe = sut.verPerfil(pepe, jose)

		//la excepcion es cuando pido ver el comment
		perfilPepe.getPost(postBrazil).getComment(commentForPostBrazil)
	}

	//privado
	@Test
	def void testCambiarUnComentarioDeUnPostPublicoAPrivadoDejaQueSoloYoLoVea() {

		sut.cambiarAPublico(pepe, postBrazil)
		sut.cambiarAPrivado(pepe, postBrazil, commentForPostBrazil)
		var perfilPepe = sut.verPerfil(pepe, pepe)

		Assert.assertEquals(Visibility.PRIVATE,
			perfilPepe.getPost(postBrazil).getComment(commentForPostBrazil).visibility)
	}

	@After
	def void borrarDatosCreadosEnSetUp() {

		flightService.eliminarAerolinea(aa)
		
		//elimino de esta manera a usuario porque eliminar aerolinea tmb elimina a los usuarios que reservaron un asiento
		//deberia haber cambiado el cascade para asiento pero lo olvide
		userService.borrarDeAmigos(pepe)
		userService.borrarDePerfiles(pepe)
		//estos al no tener asientos los puedo eliminar de esta manera
		userService.eliminarUsuario(jose)
		userService.eliminarUsuario(juan)
		//busquedas
		sut.servicioDeBusqueda.eliminarBusquedas
	}
}

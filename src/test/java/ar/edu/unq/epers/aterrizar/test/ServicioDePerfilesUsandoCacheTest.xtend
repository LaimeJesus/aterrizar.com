package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.Test
import org.junit.After
import ar.edu.unq.epers.aterrizar.domain.perfiles.DestinoPost
import ar.edu.unq.epers.aterrizar.servicios.ServicioRegistroUsuarioConHibernate
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.servicios.ServicioDePerfilesConCache
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeCacheDePerfiles
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeReservaDeVuelos
import ar.edu.unq.epers.aterrizar.domain.vuelos.Aerolinea
import ar.edu.unq.epers.aterrizar.domain.vuelos.Asiento
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeAmigos
import org.junit.Assert
import ar.edu.unq.epers.aterrizar.domain.vuelos.Vuelo
import ar.edu.unq.epers.aterrizar.domain.vuelos.Tramo
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria

class ServicioDePerfilesUsandoCacheTest {

	Usuario pepe

	ServicioRegistroUsuarioConHibernate userService

	ServicioDeReservaDeVuelos flightService

	ServicioDePerfilesConCache sut

	Aerolinea aa

	Asiento nuevoAsiento

	DestinoPost postBrazil

	ServicioDeAmigos friendsService

	Usuario jose

	ServicioDeCacheDePerfiles servicioDeCache

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

		/////////////////////////////////////////////////////////
		//reservar
		/////////////////////////////////////////////////////////
		nuevoAsiento = flightService.reservar(pepe, aa, v1, argentinabrasil, asientolibre)

		/////////////////////////////////////////////////////////
		//perfiles
		/////////////////////////////////////////////////////////
		postBrazil = new DestinoPost("1", "Brazil")

		//////////////////////////////////////////////////////////
		//seteando system under test
		//seteando mismo servicio de amigos para sut y userService
		//agregando amigo
		//////////////////////////////////////////////////////////
		friendsService.agregarAmigo(pepe, jose)

		//////////////////////////////////////////////////////////
		//agregando post a perfil de pepe y comentario
		//////////////////////////////////////////////////////////
		sut.agregarPost(pepe, postBrazil)

	}

	def inicializarServicioPerfil() {
		userService = new ServicioRegistroUsuarioConHibernate()
		flightService = new ServicioDeReservaDeVuelos(userService)

		friendsService = userService.servicioDeAmigos

		sut = new ServicioDePerfilesConCache(userService, friendsService)

		userService.setServicioDePerfiles(sut)
		sut.servicioDeBusqueda.repositorioAerolineas = flightService.repositorioDeAerolineas
		servicioDeCache = sut.cacheDePerfiles
	}

	@Test
	def void testTraerUnPerfilLoAgregaALServicioDeCache() {
		//perfil traido desde mongo
		var perfilpepe = sut.verPerfil(pepe, pepe)
		var isCachedPerfilPepe = servicioDeCache.cached(perfilpepe.nickname)
		Assert.assertTrue(isCachedPerfilPepe)
		//perfil traido desde cassandra
		var cachedPerfil = sut.verPerfil(pepe, pepe)
		Assert.assertTrue(perfilpepe.nickname.equals(cachedPerfil.nickname))
	}

	@After
	def void after() {
		flightService.eliminarAerolinea(aa)
		userService.borrarDeAmigos(pepe)
		userService.borrarDePerfiles(pepe)
		userService.eliminarUsuario(jose)
		sut.servicioDeBusqueda.eliminarBusquedas
		servicioDeCache.disconect()
		
	}

}

package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.Test
import org.junit.After
import ar.edu.unq.epers.aterrizar.domain.redsocial.DestinoPost
import ar.edu.unq.epers.aterrizar.servicios.ServicioRegistroUsuarioConHibernate
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.servicios.ServicioDePerfilesConCache
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeCacheDePerfiles
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeReservaDeVuelos
import ar.edu.unq.epers.aterrizar.domain.vuelos.Aerolinea
import ar.edu.unq.epers.aterrizar.domain.vuelos.Asiento
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeAmigos
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil
import org.junit.Assert

class ServicioDeCacheDePerfilesTest {

	Usuario pepe

	ServicioRegistroUsuarioConHibernate userService

	ServicioDeReservaDeVuelos flightService

	ServicioDeCacheDePerfiles sut

	ServicioDePerfilesConCache servicioDePerfiles

	Aerolinea aa

	Asiento nuevoAsiento

	DestinoPost postBrazil

	ServicioDeAmigos friendsService

	Usuario jose
	
	ServicioDeCacheDePerfiles s

	@Before
	def void setUp() {

//		inicializarServicioPerfil()
//
//		/////////////////////////////////////////////////////////
//		//registrar usuario
//		/////////////////////////////////////////////////////////
//		pepe = new Usuario()
//		pepe.nickname = "pepe"
//		jose = new Usuario()
//		jose.nickname = "jose"
//
//		/////////////////////////////////////////////////////////
//		//aerolinea para reservar un asiento
//		/////////////////////////////////////////////////////////
//		aa = new Aerolinea("AerolineasArgentinas")
//
//		var v1 = new Vuelo(1)
//		aa.agregarVuelo(v1)
//		var argentinabrasil = new Tramo("Argentina", "Brazil", 100, "2016-5-10", "2016-5-11", 1)
//		v1.agregarTramo(argentinabrasil)
//		var asientolibre = new Asiento(TipoDeCategoria.PRIMERA, 50, 1)
//		argentinabrasil.agregarAsiento(asientolibre)
//
//		flightService.agregarAerolinea(aa)
//
//		userService.registrarUsuario(pepe)
//		userService.registrarUsuario(jose)
//
//		/////////////////////////////////////////////////////////
//		//reservar
//		/////////////////////////////////////////////////////////
//		nuevoAsiento = flightService.reservar(pepe, aa, v1, argentinabrasil, asientolibre)
//
//		/////////////////////////////////////////////////////////
//		//perfiles
//		/////////////////////////////////////////////////////////
//		postBrazil = new DestinoPost("1", "Brazil")
//
//		//////////////////////////////////////////////////////////
//		//seteando system under test
//		//seteando mismo servicio de amigos para sut y userService
//		//agregando amigo
//		//////////////////////////////////////////////////////////
//		friendsService.agregarAmigo(pepe, jose)
//
//		//////////////////////////////////////////////////////////
//		//agregando post a perfil de pepe y comentario
//		//////////////////////////////////////////////////////////
//		servicioDePerfiles.agregarPost(pepe, postBrazil)

	}

	def inicializarServicioPerfil() {
		userService = new ServicioRegistroUsuarioConHibernate()
		flightService = new ServicioDeReservaDeVuelos(userService)

		friendsService = userService.servicioDeAmigos

		servicioDePerfiles = new ServicioDePerfilesConCache()
		servicioDePerfiles.servicioDeAmigos = friendsService
		servicioDePerfiles.servicioDeUsuarios = userService

		userService.servicioDePerfiles = servicioDePerfiles
		servicioDePerfiles.servicioDeUsuarios = userService
		servicioDePerfiles.servicioDeBusqueda.repositorioAerolineas = flightService.repositorioDeAerolineas
		sut = servicioDePerfiles.cacheDePerfiles
	}

	//	@Test
	//	def void testTraerUnPerfilLoAgregaALServicioDeCache() {
	//		var perfilpepe = servicioDePerfiles.verPerfil(pepe, jose)
	//		var isCachedPerfilPepe = sut.cached(perfilpepe.nickname)
	//		Assert.assertTrue(isCachedPerfilPepe)
	//		println(isCachedPerfilPepe)
	//		var cachedPerfil = servicioDePerfiles.verPerfil(pepe, jose)
	//		Assert.assertTrue(perfilpepe.nickname.equals(cachedPerfil.nickname))
	//	}
	@Test
	def void testServicioDeCaching() {
		s = new ServicioDeCacheDePerfiles()
		var p = new Perfil()
		p.nickname = "pepe"
		
		s.cache(p)
		
		Assert.assertTrue(s.cached('pepe'))
	}

	@After
	def void after() {
		s.delete('pepe')
//		flightService.eliminarAerolinea(aa)
//		userService.borrarDeAmigos(pepe)
//		userService.borrarDePerfiles(pepe)
//		userService.eliminarUsuario(jose)
//		servicioDePerfiles.servicioDeBusqueda.eliminarBusquedas

	//		sut.disconect()
	}

}

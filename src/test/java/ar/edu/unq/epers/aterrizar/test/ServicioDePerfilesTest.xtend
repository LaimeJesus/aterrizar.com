package ar.edu.unq.epers.aterrizar.test

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.redsocial.Comment
import ar.edu.unq.epers.aterrizar.domain.redsocial.DestinoPost
import ar.edu.unq.epers.aterrizar.servicios.ServicioDePerfiles
import ar.edu.unq.epers.aterrizar.servicios.ServicioRegistroUsuarioConHibernate
import org.junit.Assert
import org.junit.After
import ar.edu.unq.epers.aterrizar.exceptions.NoPuedeAgregarPostException
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria
import org.junit.Before
import org.junit.Test
import ar.edu.unq.epers.aterrizar.domain.vuelos.Asiento
import ar.edu.unq.epers.aterrizar.domain.vuelos.Tramo
import ar.edu.unq.epers.aterrizar.domain.vuelos.Vuelo
import ar.edu.unq.epers.aterrizar.domain.vuelos.Aerolinea
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeReservaDeVuelos

class ServicioDePerfilesTest {

	ServicioRegistroUsuarioConHibernate userService

	ServicioDePerfiles sut

	Usuario pepe

	ServicioDeReservaDeVuelos flightService

	Aerolinea aa

	Vuelo v1

	Tramo argentinabrasil

	Asiento asientolibre

	Usuario jose
	
	DestinoPost salidaALaPlaza
	
	@Before
	def void setUp() {

		flightService = new ServicioDeReservaDeVuelos()

		pepe = new Usuario()
		pepe.nickname = "pepe"

		jose = new Usuario()
		jose.nickname = "jose"
		
		salidaALaPlaza = new DestinoPost("dia en el parque")
		
		userService = new ServicioRegistroUsuarioConHibernate()
		userService.registrarUsuario(pepe)
		userService.registrarUsuario(jose)
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

		
		userService.servicioDeAmigos.agregarAmigo(pepe,jose) // amigos
		sut.agregarPost(pepe, salidaALaPlaza)
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
	def void testAgregarUnComentarioAUnPostPropio(){
		
		val commit = new Comment("hermoso dia soleado")
		sut.comentarPost(pepe, salidaALaPlaza, commit)
		
		Assert.assertTrue("un solo post", !sut.getPerfil(pepe).getPost(salidaALaPlaza).comments.empty)
		
	}
	
	@Test
	def void borrarDatosCreadosEnSetUp() {
		
	//	userService.eliminarUsuario(pepe)
	}
}

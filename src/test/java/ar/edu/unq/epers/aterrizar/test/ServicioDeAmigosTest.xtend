package ar.edu.unq.epers.aterrizar.test

import ar.edu.unq.epers.aterrizar.domain.CreadorDeCodigos
import ar.edu.unq.epers.aterrizar.domain.CreadorDeMails
import ar.edu.unq.epers.aterrizar.domain.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.domain.Mail
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeAmigos
import ar.edu.unq.epers.aterrizar.servicios.ServicioRegistroUsuarioConHibernate
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class ServicioDeAmigosTest {

	Usuario pepe
	Usuario jose
	ServicioDeAmigos sut
	Usuario tito
	Usuario nico
	CreadorDeCodigos creadorDeCodigosMock
	EnviadorDeMails enviadorDeMailsMock
	CreadorDeMails creadorDeMailsMock
	ServicioRegistroUsuarioConHibernate loginService
	

	@Before
	def void setUp(){
		//usando servicio de login
		//inicializandolo
		//loginService = new ServicioDeRegistroDeUsuarios
		
		//var url = "jdbc:mysql://localhost:3306/aterrizar"
		//var user = 'root'
		//var pass = 'root'

		loginService = new ServicioRegistroUsuarioConHibernate

		creadorDeCodigosMock = Mockito.mock(CreadorDeCodigos)
		enviadorDeMailsMock = Mockito.mock(EnviadorDeMails)
		creadorDeMailsMock = Mockito.mock(CreadorDeMails)

		loginService.creadorDeCodigos = creadorDeCodigosMock
		loginService.enviadorDeMails = enviadorDeMailsMock
		loginService.creadorDeMails = creadorDeMailsMock

		///////////////////////////
		sut = loginService.servicioDeAmigos
		pepe = new Usuario()
		pepe.nickname = "pepe"
		jose = new Usuario()
		jose.nickname = "jose"
		tito = new Usuario()
		tito.nickname = "tito"
		nico = new Usuario()
		nico.nickname = "nico"

		loginService.registrarUsuario(pepe)
		loginService.registrarUsuario(jose)
		loginService.registrarUsuario(tito)
		loginService.registrarUsuario(nico)

		sut.agregarAmigo(pepe, jose)
	}

	@Test
	def void testRelacionarUnAmigoAumentaLaCantidadDeAmigosQueTieneEnUno() {

		var cantidadDeAmigos = sut.consultarAmigos(pepe).length

		Assert.assertEquals(1, cantidadDeAmigos)

	}

	@Test
	def void testRelacionarAVariosAmigosYContarATodosLosConocidosDebeDarmeTodosMenosUno() {
		sut.agregarAmigo(jose, tito)
		sut.agregarAmigo(tito, pepe)
		sut.agregarAmigo(nico, pepe)

		var cantidad = sut.consultarACuantoConozco(pepe)
		Assert.assertEquals(3, cantidad)
	}

	@Test
	def void testEnviarUnMensajeAumentaLaCantidadDeMensajesEnviados() {
		var antes = sut.buscarMailsEnviados(pepe).length
		var saludo = new Mail() => [
			from = pepe.nickname
			to = jose.nickname
			body = "hola"
			subject = "saludo"
			idMail = 1
		]
		sut.enviarMensajeAUnUsuario(pepe, jose, saludo)
		var despues = sut.buscarMailsEnviados(pepe).length
		var recibidos = sut.buscarMailsRecibidos(jose).length
		Assert.assertTrue(antes < despues)
		Assert.assertEquals(despues, 1)
		Assert.assertEquals(recibidos, 1)
	}
	
	/////////////////////////////////////////////
	// Eliminar amistades, mensajes
	/////////////////////////////////////////////
	
//	@Test
//	def void testEliminarLaRelacionDeAmistad(){
//		
//		var cantAmigos = sut.eliminarAmistadEntre(pepe, jose)
//	}
	

	@Test
	def void testRelacionDeAmigosGrande() {

		/* relacion1 = pepe -> je -> marcelo -> lucas -> gaston -> alan -> ronny -> pepe
		 * 
		 * marcelo <-- jose <-- pepe <--- ronny
		 * |								 |
		 * |			  					 |
		 * lucas --> gaston --------------> alan 
		 *  
		 * relacion2 = jesus -> gabriel
		 * 
		 * relacion3 = juan -> gab -> tehuel -> juan
		 * 
		 * juan -> gabriel
		 *  ^			|
		 * 	|			|
		 * 	-- tehuel --
		 * 
		 */
		///////////////////////////
		//inicializacion
		///////////////////////////
		val marcelo = new Usuario()
		marcelo.nickname = "marcelo"
		val lucas = new Usuario()
		lucas.nickname = "lucas"

		val gaston = new Usuario()
		gaston.nickname = "gaston"
		val alan = new Usuario()
		alan.nickname = "alan"
		val ronny = new Usuario()
		ronny.nickname = "ronny"

		loginService.registrarUsuario(marcelo)
		loginService.registrarUsuario(lucas)
		loginService.registrarUsuario(gaston)
		loginService.registrarUsuario(alan)
		loginService.registrarUsuario(ronny)



//		 marcelo <-- jose <-- pepe <--- ronny
//		 |								 |
//		 |			  					 |
//		 lucas --> gaston --------------> alan
		//relacion grande
		sut.agregarAmigo(jose, marcelo)
		sut.agregarAmigo(marcelo, lucas)
		sut.agregarAmigo(lucas, gaston)
		sut.agregarAmigo(gaston, alan)
		sut.agregarAmigo(alan, ronny)
		sut.agregarAmigo(ronny, pepe)

		val jesus = new Usuario()
		jesus.nickname = "jesus"
		val gabriel = new Usuario()
		gabriel.nickname = "gabriel"

		loginService.registrarUsuario(jesus)
		loginService.registrarUsuario(gabriel)

		sut.agregarAmigo(jesus, gabriel)

		val juan = new Usuario()
		juan.nickname = "juan"
		val gab = new Usuario()
		gab.nickname = "gab"
		val tehuel = new Usuario()
		tehuel.nickname = "tehuel"

		loginService.registrarUsuario(juan)
		loginService.registrarUsuario(gab)
		loginService.registrarUsuario(tehuel)

		sut.agregarAmigo(juan, gab)
		sut.agregarAmigo(gab, tehuel)
		sut.agregarAmigo(tehuel, juan)

		///////////////////////////////////////////
		//assert
		///////////////////////////////////////////
		
		//grafo mas grande
		//amigos de pepe
		var amigosDePepe = sut.consultarAmigos(pepe).length 
		Assert.assertEquals(2, amigosDePepe)
		
		var conocidosDePepe = sut.consultarACuantoConozco(pepe)
		Assert.assertEquals(6, conocidosDePepe)
		
		//grafo mediano
		var amigosDeJuan = sut.consultarACuantoConozco(juan)
		Assert.assertEquals(2, amigosDeJuan)
		
		//grafo mas chico
		var amigosDeJesus = sut.consultarACuantoConozco(jesus)
		Assert.assertEquals(1, amigosDeJesus)
		
		
		///////////////////////////////////////////
		//after
		///////////////////////////////////////////
		loginService.eliminarUsuario(marcelo)
		loginService.eliminarUsuario(lucas)
		loginService.eliminarUsuario(gaston)
		loginService.eliminarUsuario(alan)
		loginService.eliminarUsuario(ronny)

		loginService.eliminarUsuario(jesus)
		loginService.eliminarUsuario(gabriel)

		loginService.eliminarUsuario(juan)
		loginService.eliminarUsuario(gab)
		loginService.eliminarUsuario(tehuel)

	}

	@Test
	def void testEnviarMuchosMensajes(){
		var saludo = new Mail() => [
			from = pepe.nickname
			to = jose.nickname
			body = "hola"
			subject = "saludo"
			idMail = 1
		]
		var respuestaSaludo = new Mail() => [
			from = pepe.nickname
			to = jose.nickname
			body = "hola"
			subject = "saludo"
			idMail = 2
		] 
		sut.enviarMensajeAUnUsuario(pepe, jose, saludo)
		sut.enviarMensajeAUnUsuario(jose, pepe, respuestaSaludo)
		
		var enviarInfo = new Mail() => [
			from = pepe.nickname
			to = jose.nickname
			body = "alguna info"
			subject = "saludo"
			idMail = 3
		] 
		var responderInfo = new Mail() => [
			from = pepe.nickname
			to = jose.nickname
			body = "respuesta alguna info"
			subject = "saludo"
			idMail = 4
		]

		sut.enviarMensajeAUnUsuario(pepe, jose, enviarInfo)
		sut.enviarMensajeAUnUsuario(jose, pepe, responderInfo)
		
		var enviadosPepe = sut.buscarMailsEnviados(pepe).length
		var recibidosPepe = sut.buscarMailsRecibidos(pepe).length

		var enviadosJose = sut.buscarMailsEnviados(jose).length
		var recibidosJose = sut.buscarMailsRecibidos(jose).length
		
		Assert.assertEquals(enviadosJose, enviadosPepe)
		Assert.assertEquals(recibidosJose, recibidosPepe)		
		
	}

	@After
	def void borrarRelacionesCreadas() {
		loginService.eliminarUsuario(pepe)
		loginService.eliminarUsuario(jose)
		loginService.eliminarUsuario(tito)
		loginService.eliminarUsuario(nico)

	}
}

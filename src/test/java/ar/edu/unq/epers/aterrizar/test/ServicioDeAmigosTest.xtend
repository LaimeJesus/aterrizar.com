package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import ar.edu.unq.epers.aterrizar.domain.Usuario
import org.junit.Test
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeAmigos
import org.junit.Assert
import org.junit.After
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeRegistroDeUsuarios
import org.mockito.Mockito
import ar.edu.unq.epers.aterrizar.domain.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.domain.CreadorDeCodigos
import ar.edu.unq.epers.aterrizar.domain.CreadorDeMails
import ar.edu.unq.epers.aterrizar.domain.Mail

class ServicioDeAmigosTest {
	

	
	Usuario pepe
	
	Usuario jose
	
	ServicioDeAmigos sut
	
	Usuario tito
	
	Usuario nico
	
	ServicioDeRegistroDeUsuarios loginService
	
	CreadorDeCodigos creadorDeCodigosMock
	
	EnviadorDeMails enviadorDeMailsMock
	
	CreadorDeMails creadorDeMailsMock
	
	@Before
	def void setUp(){
		//usando servicio de login
		//inicializandolo
		loginService = new ServicioDeRegistroDeUsuarios
		
		var url = "jdbc:mysql://localhost:3306/aterrizar"
		var user = 'root'
		var pass = 'jstrike1234'
		
		creadorDeCodigosMock = Mockito.mock(CreadorDeCodigos)
		enviadorDeMailsMock = Mockito.mock(EnviadorDeMails)
		creadorDeMailsMock = Mockito.mock(CreadorDeMails)
		
		loginService.creadorDeCodigos = creadorDeCodigosMock
		loginService.enviadorDeMails = enviadorDeMailsMock
		loginService.creadorDeMails = creadorDeMailsMock
		
		loginService.repositorio.conectarABDConMySql(url,user,pass)
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
	def void testRelacionarUnAmigoAumentaLaCantidadDeAmigosQueTieneEnUno(){
		
		
		var cantidadDeAmigos = sut.consultarAmigos(pepe).length
		
		Assert.assertEquals(1, cantidadDeAmigos)
		
	}
	
	@Test
	def void testRelacionarAVariosAmigosYContarATodosLosConocidosDebeDarmeTodosMenosUno(){
		sut.agregarAmigo(jose,tito)
		sut.agregarAmigo(tito,pepe)
		sut.agregarAmigo(nico,pepe)
		
		var cantidad = sut.consultarACuantoConozco(pepe)
		Assert.assertEquals(3, cantidad)
	}
	
	@Test
	def void testEnviarUnMensajeAumentaLaCantidadDeMensajesEnviados(){
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
		Assert.assertEquals(despues,1)
		Assert.assertEquals(recibidos,1)
	}
	
	@After
	def void borrarRelacionesCreadas(){
		loginService.eliminarUsuario(pepe)
		loginService.eliminarUsuario(jose)
		loginService.eliminarUsuario(tito)
		loginService.eliminarUsuario(nico)
		
		loginService.repositorio.cerrarConeccion()
	}
}
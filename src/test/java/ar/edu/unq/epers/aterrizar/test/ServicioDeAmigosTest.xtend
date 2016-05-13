package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import ar.edu.unq.epers.aterrizar.domain.Usuario
import org.junit.Test
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeAmigos
import org.junit.Assert
import org.junit.After
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeRegistroDeUsuarios

class ServicioDeAmigosTest {
	

	
	Usuario pepe
	
	Usuario jose
	
	ServicioDeAmigos sudo
	
	Usuario tito
	
	Usuario nico
	
	ServicioDeRegistroDeUsuarios loginService
	
	@Before
	def void setUp(){
		loginService = new ServicioDeRegistroDeUsuarios
		
		var url = "jdbc:mysql://localhost:3306/aterrizar"
		var user = 'root'
		var pass = 'jstrike1234'
		
		loginService.repositorio.conectarABDConMySql(url,user,pass)
		sudo = loginService.servicioDeAmigos
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

		sudo.agregarAmigo(pepe, jose)
	}
	
	@Test
	def void testProbarQueRelacionarUnAmigoFunciona(){
		
		
		var cantidadDeAmigos = sudo.consultarAmigos(pepe).length
		
		Assert.assertEquals(1, cantidadDeAmigos)
		
	}
	
	@Test
	def void testProbarACuantosConozco(){
		sudo.agregarAmigo(jose,tito)
		sudo.agregarAmigo(tito,pepe)
		sudo.agregarAmigo(nico,pepe)
		
		var cantidad = sudo.consultarACuantoConozco(pepe)
		Assert.assertEquals(2, cantidad)
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
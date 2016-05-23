package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.Test
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.servicios.ServicioDePerfiles
import ar.edu.unq.epers.aterrizar.servicios.ServicioRegistroUsuarioConHibernate
import ar.edu.unq.epers.aterrizar.domain.redsocial.DestinoPost
import ar.edu.unq.epers.aterrizar.domain.redsocial.Comment
import org.junit.Assert

class ServicioDePerfilesTest {
	
	ServicioRegistroUsuarioConHibernate userService
	
	ServicioDePerfiles sut
	
	Usuario pepe
	
	Usuario jose
	
	DestinoPost salidaALaPlaza
	
	
	@Before
	def void setUp(){
		pepe = new Usuario()
		pepe.nickname = "pepe"
		
		jose = new Usuario()
		jose.nickname = "jose"
		
		salidaALaPlaza = new DestinoPost("dia en el parque")
		
		userService = new ServicioRegistroUsuarioConHibernate()
		userService.registrarUsuario(pepe)
		userService.registrarUsuario(jose)
		sut = userService.servicioDePerfiles
		
		userService.servicioDeAmigos.agregarAmigo(pepe,jose) // amigos
		sut.agregarPost(pepe, salidaALaPlaza)
	}
	
	@Test
	def void testAgregarUnPostDestinoDeUnLugarQueVisiteMeActualizaElPerfil(){
		
	}
	
	@Test
	def void testAgregarUnComentarioAUnPostPropio(){
		
		val commit = new Comment("hermoso dia soleado")
		sut.comentarPost(pepe, salidaALaPlaza, commit)
		
		Assert.assertTrue("un solo post", !sut.getPerfil(pepe).getPost(salidaALaPlaza).comments.empty)
		
	}
	
	@Test
	def void borrarDatosCreadosEnSetUp(){
		sut.eliminarPerfil(pepe)
	}
}
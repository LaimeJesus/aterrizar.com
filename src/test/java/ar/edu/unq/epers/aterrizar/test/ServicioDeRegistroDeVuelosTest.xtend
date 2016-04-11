package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.After
import org.junit.Test
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import org.junit.Assert

class ServicioDeRegistroDeVuelosTest {
	
	Aerolinea unaAeroDePrueba
	
	RepositorioAerolinea repoPrueba
	
	@Before
	def void setUp(){
		unaAeroDePrueba = new Aerolinea
		repoPrueba = new RepositorioAerolinea
		
		unaAeroDePrueba.nombreAerolinea = "prueba"
			SessionManager.runInSession([
			repoPrueba.persistir(unaAeroDePrueba)
			unaAeroDePrueba
		])
	}
	
	@Test
	def void testCrearAerolineaParaProbarBaseDeDatos(){
		var existe = SessionManager.runInSession([
			repoPrueba.contiene("nombreAerolinea", unaAeroDePrueba.nombreAerolinea)
		])
		
		Assert.assertEquals(true, existe)
	}
	
	@After
	def void testBorrarObjetosCreadosEnSetUp(){
		SessionManager.runInSession([
			new RepositorioAerolinea().borrar("nombreAerolinea", unaAeroDePrueba.nombreAerolinea)
			unaAeroDePrueba
		])
	}
	
}
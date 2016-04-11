package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.After
import org.junit.Test
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import org.junit.Assert
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.domain.Tramo

class ServicioDeRegistroDeVuelosTest {
	
	Aerolinea unaAeroDePrueba
	
	RepositorioAerolinea repoPrueba
	
	ArrayList<Vuelo> vuelos
	
	Vuelo vuelo
	
	@Before
	def void setUp(){
		unaAeroDePrueba = new Aerolinea
		vuelos = new ArrayList<Vuelo>()
		vuelo = new Vuelo()
		vuelo.nroVuelo = 1
		vuelo.tramos = new ArrayList<Tramo>()
		
		vuelos.add(vuelo)
		unaAeroDePrueba.vuelos = vuelos 
		unaAeroDePrueba.nombreAerolinea = "prueba"
		repoPrueba = new RepositorioAerolinea
		
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
		/* 
		SessionManager.runInSession([
			new RepositorioAerolinea().borrar("nombreAerolinea", unaAeroDePrueba.nombreAerolinea)
			unaAeroDePrueba
		])
		
		*/
	}
	
}
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
import ar.edu.unq.epers.aterrizar.domain.Asiento
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria
import ar.edu.unq.epers.aterrizar.domain.buscador.CriterioPorOrigen
import ar.edu.unq.epers.aterrizar.domain.buscador.BuscadorDeVuelos
import java.sql.Date
import ar.edu.unq.epers.aterrizar.domain.buscador.CriterioPorNombreDeAerolinea

class ServicioDeRegistroDeVuelosTest {
	
	Aerolinea unaAeroDePrueba
	
	RepositorioAerolinea repoPrueba
	
	ArrayList<Vuelo> vuelos
	
	Vuelo vuelo
	
	ArrayList<Tramo> tramos
	
	TipoDeCategoria business
	
	BuscadorDeVuelos buscador
	
	CriterioPorNombreDeAerolinea criterioNombre
	
	CriterioPorOrigen criterioOrigen
	
	@Before
	def void setUp(){
		unaAeroDePrueba = new Aerolinea
		vuelos = new ArrayList<Vuelo>()
		vuelo = new Vuelo()
		vuelo.nroVuelo = 1
		tramos = new ArrayList<Tramo>()
		var tramo1 = new Tramo()
		tramo1.origen = "Argentina"
		tramo1.destino = "Brazil"
		tramo1.precioBase = 0
		
		var asientos = new ArrayList<Asiento>()
		business = TipoDeCategoria.BUSINESS
		business.factorPrecio = 10
		var asiento = new Asiento()
		asiento.categoria = business
		asientos.add(asiento)
		
		tramo1.asientos = asientos
		tramo1.fechaDeLlegada = Date.valueOf('2016-05-12')
		tramo1.fechaDeSalida = Date.valueOf('2016-05-12')
		tramo1.precioBase = 100
		tramos.add(tramo1)
		
		vuelo.tramos = tramos
		vuelos.add(vuelo)
		unaAeroDePrueba.vuelos = vuelos 
		unaAeroDePrueba.nombreAerolinea = "prueba"
		
		repoPrueba = new RepositorioAerolinea
		
			SessionManager.runInSession([
			repoPrueba.persistir(unaAeroDePrueba)
			unaAeroDePrueba
		])
		buscador = new BuscadorDeVuelos(repoPrueba)
		criterioNombre = new CriterioPorNombreDeAerolinea("prueba")
		criterioOrigen = new CriterioPorOrigen("Argentina")
	}
	 
	@Test
	def void testCrearAerolineaParaProbarBaseDeDatos(){
		var existe = SessionManager.runInSession([
			repoPrueba.contiene("nombreAerolinea", unaAeroDePrueba.nombreAerolinea)
		])
		
		Assert.assertEquals(true, existe)
		
	}
	
	
	@Test
	def void testCriterioPorOrigen(){

		var resultados = buscador.buscarPorCriterio(criterioOrigen)
		Assert.assertEquals(resultados.length, 1)
		
	}
	 
	@Test
	def void testCriterioPorNombreAerolinea(){
		var resultados = buscador.buscarPorCriterio(criterioNombre)
		Assert.assertEquals(resultados.length, 1)
	}
	/* 
	@Test
	def void testCriterioPorConjuncion(){
		var criterio = criterioOrigen.componerPorConjuncion(criterioNombre)
		var resultados = buscador.buscarPorCriterio(criterio)
		
		Assert.assertEquals(resultados.length, 1)
	}
	*/
	@After
	def void testBorrarObjetosCreadosEnSetUp(){
		
		SessionManager.runInSession([
			new RepositorioAerolinea().borrar("nombreAerolinea", unaAeroDePrueba.nombreAerolinea)
			unaAeroDePrueba
		])
		
	
	}

	
}
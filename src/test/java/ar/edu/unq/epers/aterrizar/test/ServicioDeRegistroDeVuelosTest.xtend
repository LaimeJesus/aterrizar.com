package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.After
import org.junit.Test
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import org.junit.Assert
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import ar.edu.unq.epers.aterrizar.domain.Tramo
import ar.edu.unq.epers.aterrizar.domain.buscador.CriterioPorOrigen
import ar.edu.unq.epers.aterrizar.domain.buscador.BuscadorDeVuelos
import ar.edu.unq.epers.aterrizar.domain.buscador.CriterioPorNombreDeAerolinea
import ar.edu.unq.epers.aterrizar.domain.buscador.Criterio
import ar.edu.unq.epers.aterrizar.domain.buscador.CriterioPorVueloDisponible
import ar.edu.unq.epers.aterrizar.domain.buscador.CriterioPorDestino
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria

class ServicioDeRegistroDeVuelosTest {
	
	Aerolinea prueba
	Aerolinea aerolineasArgentinas
	
	RepositorioAerolinea repoPrueba
	
	Vuelo vuelo
	
	BuscadorDeVuelos buscador
	
	CriterioPorNombreDeAerolinea criterioNombre
	
	CriterioPorOrigen criterioOrigen
	
	Criterio criterioVueloDisponible
	
	CriterioPorDestino criterioDestino
	
	
	@Before
	def void setUp(){
		
		repoPrueba = new RepositorioAerolinea
		
		aerolineasArgentinas = new Aerolinea("Aerolineas Argentinas")
		
		var vueloNroUno = new Vuelo(1)
		var vueloNroDos = new Vuelo(2)
		var vueloNroTres = new Vuelo(3)
		
		aerolineasArgentinas.vuelos.add(vueloNroUno)
		aerolineasArgentinas.vuelos.add(vueloNroDos)
		aerolineasArgentinas.vuelos.add(vueloNroTres)
		
		//////////////////////////////////////
		
		var tramoArgentinaUruguay = new Tramo("Argentina", "Uruguay", 20, '2016-05-12', '2016-05-12')
		tramoArgentinaUruguay.asientosStandard()
		
		var tramoUruguayBrasil = new Tramo("Uruguay", "Brasil", 50, '2016-05-13', '2016-05-12')
		tramoUruguayBrasil.asientosStandard()
		
		vueloNroUno.agregarTramo(tramoArgentinaUruguay)
		vueloNroUno.agregarTramo(tramoUruguayBrasil)
		
		//////////////////////////////////////
		
		var tramoArgentinaUSA= new Tramo("Argentina", "USA", 20, '2016-05-12', '2016-06-12')
		tramoArgentinaUSA.asientosStandard()
		
		vueloNroDos.agregarTramo(tramoArgentinaUSA)
		
		//////////////////////////////////////
		
		var tramoArgentinaChile = new Tramo("Argentina", "Chile", 10, '2016-05-12', '2016-05-20')
		tramoArgentinaChile.asientosStandard()
		
		var tramoChileAustralia = new Tramo("Chile", "Australia", 50, '2016-05-20', '2016-06-1')
		tramoChileAustralia.asientosStandard()
		
		var tramoAustraliaJapon = new Tramo("Australia", "Japon", 30, '2016-06-1', '2016-06-12')
		tramoAustraliaJapon.crearAsientos(TipoDeCategoria.BUSINESS, 5, 5)

		vueloNroTres.agregarTramo(tramoArgentinaChile)
		vueloNroTres.agregarTramo(tramoChileAustralia)
		vueloNroTres.agregarTramo(tramoAustraliaJapon)
		
		//////////////////////////////////////
		
		SessionManager.runInSession([
			repoPrueba.persistir(aerolineasArgentinas)
			aerolineasArgentinas
		])


		
		prueba = new Aerolinea("prueba")
		vuelo = new Vuelo(4)
		var tramo1 = new Tramo("Argentina", "Brazil", 100, '2016-05-01', '2016-05-02')
		tramo1.asientosStandard()
		
		vuelo.agregarTramo(tramo1)
		prueba.vuelos.add(vuelo)
				
		SessionManager.runInSession([
			repoPrueba.persistir(prueba)
			void
		])


		
		buscador = new BuscadorDeVuelos(repoPrueba)
		criterioNombre = new CriterioPorNombreDeAerolinea("prueba")
		criterioOrigen = new CriterioPorOrigen("Argentina")
		criterioDestino = new CriterioPorDestino("Japon")
		criterioVueloDisponible = new CriterioPorVueloDisponible()
	}
	 
	@Test
	def void testCrearAerolineaParaProbarBaseDeDatos(){
		var existe = SessionManager.runInSession([
			repoPrueba.contiene("nombreAerolinea", prueba.nombreAerolinea)
		])
		
		Assert.assertEquals(true, existe)
		
	}
	
	
	@Test
	def void testCriterioPorOrigen(){

		var resultados = buscador.buscarPorCriterio(criterioOrigen)
		Assert.assertEquals(resultados.length, 4)
		
	}
	 
	@Test
	def void testCriterioPorNombreAerolinea(){
		var resultados = buscador.buscarPorCriterio(criterioNombre)
		Assert.assertEquals(resultados.length, 1)
	}
	
	@Test
	def void testCriterioPorVueloDisponible(){
		var resultados = buscador.buscarPorCriterio(criterioVueloDisponible)
		Assert.assertEquals(resultados.length, 4)
	}
	
	
	@Test
	def void testCriterioPorConjuncion(){
		var criterio = criterioOrigen.componerPorConjuncion(criterioNombre)
		var resultados = buscador.buscarPorCriterio(criterio)
		
		Assert.assertEquals(resultados.length, 1)
	}
	@Test
	def void testCriterioPorDisjuncion(){
		var criterio = criterioOrigen.componerPorDisjuncion(criterioDestino)
		var resultados = buscador.buscarPorCriterio(criterio)
		
		Assert.assertEquals(resultados.length, 4)
	}

	@Test
	def void testBuscarPorOrdenDeMenorCostoDebeDarmeLosVuelosPorMenorCostoPrimero(){
		buscador.ordenarPorMenorCosto()
		var resultados = buscador.buscarPorCriterio(criterioOrigen)
		
		Assert.assertEquals(resultados.get(0).nroVuelo, 2)
	}
	@Test
	def void testBuscarPorOrdenMenorTrayecto(){
		buscador.ordenarPorMenorEscala()
		var resultados = buscador.buscarPorCriterio(criterioOrigen)
		
		// el 4 o el 2 ya que tienen un solo tramo
		Assert.assertEquals(resultados.get(0).nroVuelo, 4)
	}
	@Test
	def void testBuscarPorMenorDuracion(){
		buscador.ordenarPorMenorDuracion()
		var resultados = buscador.buscarPorCriterio(criterioOrigen)
		
		Assert.assertEquals(resultados.get(0).nroVuelo, 2)
	}
	@After
	def void testBorrarObjetosCreadosEnSetUp(){
		
		SessionManager.runInSession([
			repoPrueba.borrar("nombreAerolinea", prueba.nombreAerolinea)
			repoPrueba.borrar("nombreAerolinea", aerolineasArgentinas.nombreAerolinea)
			void
		])
	}

	
}
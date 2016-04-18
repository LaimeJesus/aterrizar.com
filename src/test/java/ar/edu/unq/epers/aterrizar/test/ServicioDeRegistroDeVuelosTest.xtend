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
import ar.edu.unq.epers.aterrizar.domain.buscador.OrdenPorCostoDeVuelo
import ar.edu.unq.epers.aterrizar.domain.buscador.OrdenPorTrayecto
import ar.edu.unq.epers.aterrizar.domain.buscador.OrdenPorDuracion
import ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda

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
	
	Busqueda busqueda
	
	
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
		
		var tramoUruguayBrasil = new Tramo("Uruguay", "Brasil", 50, '2016-05-10', '2016-05-12')
		tramoUruguayBrasil.asientosStandard()
		
		vueloNroUno.agregarTramo(tramoArgentinaUruguay)
		vueloNroUno.agregarTramo(tramoUruguayBrasil)
		
		//////////////////////////////////////
		
		var tramoArgentinaUSA= new Tramo("Argentina", "USA", 20, '2016-05-12', '2016-06-12')
		tramoArgentinaUSA.asientosStandard()
		
		vueloNroDos.agregarTramo(tramoArgentinaUSA)
		
		//////////////////////////////////////
		
		var tramoArgentinaChile = new Tramo("Argentina", "Chile", 10, '2016-5-12', '2016-5-20')
		tramoArgentinaChile.asientosStandard()
		
		var tramoChileAustralia = new Tramo("Chile", "Australia", 50, '2016-5-20', '2016-6-1')
		tramoChileAustralia.asientosStandard()
		
		var tramoAustraliaJapon = new Tramo("Australia", "Japon", 30, '2016-6-1', '2016-6-12')
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
		var tramo1 = new Tramo("Argentina", "Brazil", 100, '2016-1-5', '2016-2-5')
		var tramo2 = new Tramo("Brazil", "Mexico", 200, '2016-2-5', '2016-3-5')
		tramo1.asientosStandard()
		
		vuelo.agregarTramo(tramo1)
		vuelo.agregarTramo(tramo2)
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
		busqueda = new Busqueda(criterioOrigen)

		var resultados = buscador.buscarVuelos(busqueda)
		Assert.assertEquals(resultados.length, 4)
		
	}
	 
	@Test
	def void testCriterioPorNombreAerolinea(){
		busqueda = new Busqueda(criterioNombre)
		var resultados = buscador.buscarVuelos(busqueda)
		Assert.assertEquals(resultados.length, 1)
	}
	
	@Test
	def void testCriterioPorVueloDisponible(){
		busqueda = new Busqueda(criterioVueloDisponible)
		var resultados = buscador.buscarVuelos(busqueda)
		Assert.assertEquals(resultados.length, 4)
	}
	
	
	@Test
	def void testCriterioPorConjuncion(){
		var criterio = criterioOrigen.componerPorConjuncion(criterioNombre)
		busqueda = new Busqueda(criterio)
		var resultados = buscador.buscarVuelos(busqueda)
		
		Assert.assertEquals(resultados.length, 1)
	}
	@Test
	def void testCriterioPorDisjuncion(){
		var criterio = criterioOrigen.componerPorDisjuncion(criterioDestino)
		busqueda = new Busqueda(criterio)
		var resultados = buscador.buscarVuelos(busqueda)
		
		Assert.assertEquals(resultados.length, 4)
	}

	@Test
	def void testBuscarPorOrdenDeMenorCosto(){
		var ordenCosto = new OrdenPorCostoDeVuelo()
		ordenCosto.porMenorOrden
		busqueda = new Busqueda(criterioOrigen, ordenCosto)
		var resultados = buscador.buscarVuelos(busqueda)
		
		Assert.assertEquals(2, resultados.head.nroVuelo)
	}
	@Test
	def void testBuscarPorOrdenMenorTrayecto(){
		var ordenTrayecto = new OrdenPorTrayecto()
		ordenTrayecto.porMenorOrden
		busqueda = new Busqueda(criterioOrigen, ordenTrayecto)		
		var resultados = buscador.buscarVuelos(busqueda)
		var vuelo = resultados.head
		
		Assert.assertEquals(2, vuelo.nroVuelo)
	}
	@Test
	def void testBuscarPorMenorDuracion(){
		var ordenDuracion = new OrdenPorDuracion()
		ordenDuracion.porMenorOrden
		busqueda = new Busqueda(criterioOrigen, ordenDuracion)
		var resultados = buscador.buscarVuelos(busqueda)
		
		Assert.assertEquals(1, resultados.get(0).nroVuelo)
		
	}
	
//	@After
//	def void testBorrarObjetosCreadosEnSetUp(){
//		
//		SessionManager.runInSession([
//			repoPrueba.borrar("nombreAerolinea", prueba.nombreAerolinea)
//			repoPrueba.borrar("nombreAerolinea", aerolineasArgentinas.nombreAerolinea)
//			void
//		])
//	}

}
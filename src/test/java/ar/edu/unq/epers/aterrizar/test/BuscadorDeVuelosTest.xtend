package ar.edu.unq.epers.aterrizar.test

import org.junit.Test
import org.junit.Before
import ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda
import org.junit.Assert
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria
import ar.edu.unq.epers.aterrizar.domain.Tramo
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import ar.edu.unq.epers.aterrizar.domain.buscador.BuscadorDeVuelos
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorDuracion
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorCostoDeVuelo
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorEscalas
import org.junit.After
import ar.edu.unq.epers.aterrizar.persistence.SessionManager
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorOrigen
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorNombreDeAerolinea
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorDestino
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorVueloDisponible
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorFechaDeLlegada
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorFechaDeSalida
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorCategoriaDeAsiento

/*
 * Esta clase esta para testear al buscador de vuelos integrado con busquedas, estas tienen criterios y ordenes.
 * Es decir busca de las aerolineas persistidas en la bd, los vuelos.
 * 
 */


class BuscadorDeVuelosTest {
	
	BuscadorDeVuelos sudo
	
	Busqueda busqueda
	
	Aerolinea aerolineasArgentinas
	
	RepositorioAerolinea repoPrueba
	
	OrdenPorEscalas ordenPorEscala
	
	OrdenPorCostoDeVuelo ordenPorCosto
	
	OrdenPorDuracion ordenPorDuracion
	
	CriterioPorOrigen origenArgentina
	
	CriterioPorNombreDeAerolinea nombreAerolineas
	
	CriterioPorDestino destinoJapon
	
	CriterioPorVueloDisponible vueloDisponible
	
	CriterioPorFechaDeLlegada llegada2016520
	CriterioPorFechaDeSalida salida2016512
	
	CriterioPorCategoriaDeAsiento categoriaTurista
	
	
	@Before
	def void setUp(){
		//Repositorio aerolinea
		repoPrueba = new RepositorioAerolinea
		
		
///////////////////////////////////////////////////////////////
// Creacion de dos aerolineas con sus vuelos que tienen tramos que tienen asientos
///////////////////////////////////////////////////////////////	

		//////////////////////////////////////
		//Aerolineas Argentinas
		//////////////////////////////////////
		
		aerolineasArgentinas = new Aerolinea("Aerolineas Argentinas")
		
		//////////////////////////////////////
		//vuelos
		//////////////////////////////////////
				
		var vueloNroUno = new Vuelo(1)
		var vueloNroDos = new Vuelo(2)
		var vueloNroTres = new Vuelo(3)
		
		aerolineasArgentinas.agregarVuelo(vueloNroUno)
		aerolineasArgentinas.agregarVuelo(vueloNroDos)
		aerolineasArgentinas.agregarVuelo(vueloNroTres)
		
		//////////////////////////////////////
		//tramos vuelo 1
		//////////////////////////////////////
		
		var tramoArgentinaUruguay = new Tramo("Argentina", "Uruguay", 20, '2016-05-12', '2016-05-12')
		tramoArgentinaUruguay.asientosStandard()
		
		var tramoUruguayBrasil = new Tramo("Uruguay", "Brasil", 50, '2016-05-10', '2016-05-12')
		tramoUruguayBrasil.asientosStandard()
		
		vueloNroUno.agregarTramo(tramoArgentinaUruguay)
		vueloNroUno.agregarTramo(tramoUruguayBrasil)
		
		//////////////////////////////////////
		//tramos vuelo 2
		//////////////////////////////////////

		
		var tramoArgentinaUSA= new Tramo("Argentina", "USA", 20, '2016-05-12', '2016-06-11')
		tramoArgentinaUSA.asientosStandard()
		
		vueloNroDos.agregarTramo(tramoArgentinaUSA)
		
		//////////////////////////////////////
		//tramos vuelo 3
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
		//persistiendo aerolineas argentinas
		//////////////////////////////////////
		
		SessionManager.runInSession([
			repoPrueba.persistir(aerolineasArgentinas)
			void
		])
		
		//////////////////////////////////////
		//inicializando buscador
		//////////////////////////////////////
		sudo = new BuscadorDeVuelos(repoPrueba)
		
		//////////////////////////////////////
		//inicializando busqueda
		//////////////////////////////////////
		
		busqueda = new Busqueda()

		//////////////////////////////////////
		//inicializando ordenes
		//////////////////////////////////////

		ordenPorEscala = new OrdenPorEscalas()
		ordenPorCosto = new OrdenPorCostoDeVuelo()
		ordenPorDuracion = new OrdenPorDuracion()

		//////////////////////////////////////
		//inicializando filtros
		//////////////////////////////////////
	
		origenArgentina = new CriterioPorOrigen("Argentina")
		destinoJapon = new CriterioPorDestino("Japon")
		nombreAerolineas = new CriterioPorNombreDeAerolinea("Aerolineas Argentinas")
		vueloDisponible = new CriterioPorVueloDisponible()
		llegada2016520 = new CriterioPorFechaDeLlegada('2016-5-20')
		salida2016512 = new CriterioPorFechaDeSalida('2016-5-12')
		categoriaTurista = new CriterioPorCategoriaDeAsiento(TipoDeCategoria.TURISTA)

	}
	
	//ordenar por duracion de vuelo
	
	@Test
	def void testBuscarVuelosPorOrdenDeMenorDuracion(){
		ordenPorDuracion.porMenorOrden
		busqueda.ordenarPor(ordenPorDuracion)

		var vuelos = sudo.buscarVuelos(busqueda)
		var vueloConMenorDuracion = vuelos.head.nroVuelo
		
		Assert.assertEquals(1, vueloConMenorDuracion)
	}
	@Test
	def void testBuscarVuelosPorOrdenDeMayorDuracion(){
		ordenPorDuracion.porMayorOrden
		busqueda.ordenarPor(ordenPorDuracion)

		var vuelos = sudo.buscarVuelos(busqueda)
		var vueloConMayorDuracion = vuelos.head.nroVuelo
		
		Assert.assertEquals(3, vueloConMayorDuracion)
	}
	
	//ordenar por costo de vuelo
	
	@Test
	def void testBuscarVuelosOrdenadosPorMenorCosto(){
		
		ordenPorCosto.porMenorOrden
		busqueda.ordenarPor(ordenPorCosto)

		var vuelos = sudo.buscarVuelos(busqueda)
		var vueloConMenorCosto = vuelos.head.nroVuelo
		
		Assert.assertEquals(2, vueloConMenorCosto)
	}
	@Test
	def void testBuscarVuelosOrdenadosPorMayorCosto(){
		
		ordenPorCosto.porMayorOrden
		busqueda.ordenarPor(ordenPorCosto)

		var vuelos = sudo.buscarVuelos(busqueda)
		var vueloConMayorCosto = vuelos.head.nroVuelo
		
		Assert.assertEquals(3, vueloConMayorCosto)
	}

	/*
	 * ordenar por escalas
	 */
	
	@Test
	def void testBuscarVuelosPorOrdenDeMenorEscala(){
		
		ordenPorEscala.porMenorOrden
		System.out.println(ordenPorEscala.orderBy)

		busqueda.ordenarPor(ordenPorEscala)

		var vuelos = sudo.buscarVuelos(busqueda)
		var vueloConMenorEscala = vuelos.head.nroVuelo
		
		
		Assert.assertEquals(2, vueloConMenorEscala)
	}
	
	@Test
	def void testBuscarVuelosPorOrdenDeMayorEscala(){
		ordenPorEscala.porMayorOrden
		busqueda.ordenarPor(ordenPorEscala)

		var vuelos = sudo.buscarVuelos(busqueda)
		var vueloConMayorEscala = vuelos.head.nroVuelo
		
		Assert.assertEquals(3, vueloConMayorEscala)		
	}
	
	
	@Test
	def void testBuscarVuelosPorOrdenDeMayorEscalaYMayorDuracion(){
		var ordenCompuesto = ordenPorEscala.and(ordenPorDuracion)
		ordenCompuesto.porMayorOrden
		busqueda.orden = ordenCompuesto
		
		var vuelos = sudo.buscarVuelos(busqueda)
		var vueloConMayorEscalaYMayorDuracion = vuelos.head.nroVuelo
		
		Assert.assertEquals(3, vueloConMayorEscalaYMayorDuracion)
	}	

	//no funciona como esperaba

	@Test
	def void testBuscarVuelosPorOrdenDeMayorEscalaYMenorCosto(){
		ordenPorEscala.porMayorOrden
		ordenPorCosto.porMenorOrden
		
		var ordenCompuesto = ordenPorEscala.and(ordenPorCosto)

		busqueda.orden = ordenCompuesto
		
		var vuelos = sudo.buscarVuelos(busqueda)
		var vueloConMayorEscalaYMayorDuracion = vuelos.head.nroVuelo
		
		Assert.assertEquals(3, vueloConMayorEscalaYMayorDuracion)
	}	

	// busquedas con condiciones

	@Test
	def void testFiltrarPorOrigenArgentina(){
		busqueda.filtrarPor(origenArgentina)
		var resultados = sudo.buscarVuelos(busqueda)

		Assert.assertEquals(resultados.length, 3)		
	}
	 
	@Test
	def void testFiltrarPorDestinoJapon(){
		busqueda.filtrarPor(destinoJapon)
		var resultados = sudo.buscarVuelos(busqueda)
		
		Assert.assertEquals(resultados.length, 1)
	} 
	 
	@Test
	def void testFiltrarPorNombreAerolinea(){
		busqueda.filtrarPor(nombreAerolineas)
		var resultados = sudo.buscarVuelos(busqueda)
		Assert.assertEquals(resultados.length, 3)
	}
	
	@Test
	def void testFiltrarPorVueloDisponible(){
		busqueda.filtrarPor(vueloDisponible)
		var resultados = sudo.buscarVuelos(busqueda)
		Assert.assertEquals(resultados.length, 3)
	}
	
	@Test
	def void testFiltrarPorOrigenArgentinaYDestinoJapon(){
		var criterio = origenArgentina.and(destinoJapon)
		busqueda = new Busqueda(criterio)
		var resultados = sudo.buscarVuelos(busqueda)
		
		Assert.assertEquals(resultados.length, 0)
	}
	@Test
	def void testFiltrarPorOrigenArgentinaODestinoJapon(){
		var criterio = origenArgentina.or(destinoJapon)
		busqueda = new Busqueda(criterio)
		var resultados = sudo.buscarVuelos(busqueda)
		
		Assert.assertEquals(resultados.length, 3)
	}

	@Test
	def void testFiltrarPorFechaDeLlegada(){
		
		busqueda.filtrarPor(llegada2016520)
		var resultados = sudo.buscarVuelos(busqueda)
		
		Assert.assertEquals(1, resultados.length)
	}	

	@Test
	def void testFiltrarPorFechaDeSalida(){
		busqueda.filtrarPor(salida2016512)
		var resultados = sudo.buscarVuelos(busqueda)
		
		Assert.assertEquals(resultados.length, 3)
	}	
	@Test
	def void testFiltrarPorCategoriaTurista(){
		busqueda.filtrarPor(categoriaTurista)
		var resultados = sudo.buscarVuelos(busqueda)
		
		Assert.assertEquals(resultados.length, 3)
	}

	@After
	def void testBorrarBusquedasCreadasEnElSetUp(){
		SessionManager.runInSession[|
		val session = SessionManager.getSession()
		session.delete(aerolineasArgentinas)
		null
		]
		
		sudo.eliminarBusquedas()
	}
	
}
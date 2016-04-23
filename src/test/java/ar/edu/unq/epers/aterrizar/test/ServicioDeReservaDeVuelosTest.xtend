package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.After
import org.junit.Test
import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import org.junit.Assert
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import ar.edu.unq.epers.aterrizar.domain.Tramo
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria
import ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeReservaDeVuelos
import ar.edu.unq.epers.aterrizar.domain.Asiento
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorNombreDeAerolinea
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorCostoDeVuelo

class ServicioDeReservaDeVuelosTest {
	
	Aerolinea prueba
	Aerolinea aerolineasArgentinas

	ServicioDeReservaDeVuelos sudo
	Busqueda busqueda
	
	@Before
	def void setUp(){
		
		
		sudo = new ServicioDeReservaDeVuelos
		
		/////////////
				
		aerolineasArgentinas = new Aerolinea("Aerolineas Argentinas")
		
		var vueloNroUno = new Vuelo(1)
		var vueloNroDos = new Vuelo(2)
		var vueloNroTres = new Vuelo(3)
		
		aerolineasArgentinas.agregarVuelo(vueloNroUno)
		aerolineasArgentinas.agregarVuelo(vueloNroDos)
		aerolineasArgentinas.agregarVuelo(vueloNroTres)
		
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
		
		prueba = new Aerolinea("prueba")
		
		var vuelo = new Vuelo(4)
		var tramoArgentinaBrasil = new Tramo("Argentina", "Brasil", 100, '2016-1-5', '2016-2-5')
		var tramoBrasilMexico = new Tramo("Brasil", "Mexico", 200, '2016-2-5', '2016-3-5')
		var tramoMexicoEstadosUnidos = new Tramo("Mexico", "USA", 100, '2016-3-5', '2016-3-6')
		var tramoEstadosUnidosArgentina = new Tramo("USA", "Argentina", 100, '2016-3-6', '2016-3-9')
		
		//asiento ocupado
		var asientoOcupadoPrimera = new Asiento(TipoDeCategoria.PRIMERA, 50)
		var usuarioOcupantePrimera = new Usuario()
		usuarioOcupantePrimera.nickname = "pepe"
		asientoOcupadoPrimera.reservadoPorUsuario = usuarioOcupantePrimera 

		//asiento ocupado
		var asientoOcupadoBusiness = new Asiento(TipoDeCategoria.BUSINESS, 50)
		var usuarioOcupanteBusiness = new Usuario()
		usuarioOcupanteBusiness.nickname = "jose"
		asientoOcupadoBusiness.reservadoPorUsuario = usuarioOcupanteBusiness

		//asiento ocupado
		var asientoOcupadoTurista = new Asiento(TipoDeCategoria.TURISTA, 50)
		var usuarioOcupanteTurista = new Usuario()
		usuarioOcupanteTurista.nickname = "carlos"
		asientoOcupadoTurista.reservadoPorUsuario = usuarioOcupanteTurista

		//asiento desocupado
		var asientoLibrePrimera = new Asiento(TipoDeCategoria.PRIMERA, 100)
		
		//agrgando asientos ocupados a tramos
		tramoArgentinaBrasil.agregarAsiento(asientoOcupadoPrimera)
		tramoBrasilMexico.agregarAsiento(asientoOcupadoBusiness)
		tramoMexicoEstadosUnidos.agregarAsiento(asientoOcupadoTurista)
		tramoEstadosUnidosArgentina.agregarAsiento(asientoLibrePrimera)
		
		//agregando tramos al vuelo
		vuelo.agregarTramo(tramoArgentinaBrasil)
		vuelo.agregarTramo(tramoBrasilMexico)
		vuelo.agregarTramo(tramoMexicoEstadosUnidos)
		vuelo.agregarTramo(tramoEstadosUnidosArgentina)
		
		prueba.agregarVuelo(vuelo)
	

		sudo.agregarAerolinea(aerolineasArgentinas)
		sudo.agregarAerolinea(prueba)
	}
	 
	@Test
	def void testCrearAerolineaParaProbarBaseDeDatos(){
		var existeAerolienas = sudo.existeAeroliena(aerolineasArgentinas)
		var existePrueba = sudo.existeAeroliena(prueba)
		
		Assert.assertEquals(true, existeAerolienas)
		Assert.assertEquals(true, existePrueba)
	}
	
	
	@Test
	def void testBuscarVuelosPorUnTipoDeCriterio(){
		var filtro = new CriterioPorNombreDeAerolinea("Aerolineas Argentinas")
		var orden = new OrdenPorCostoDeVuelo
		orden.porMenorOrden
		busqueda = new Busqueda(filtro, orden)

		var resultados = sudo.buscar(busqueda)
		
		//verificar si funciona el filtro
		Assert.assertEquals(resultados.length, 3)
		
		//vrificar orden
		Assert.assertEquals(resultados.head.nroVuelo, 2)
		
	}
	 
//	@Test
//	def void testCriterioPorNombreAerolinea(){
//		busqueda = new Busqueda(criterioNombre)
//		var resultados = buscador.buscarVuelos(busqueda)
//		Assert.assertEquals(resultados.length, 1)
//	}
//	
//	@Test
//	def void testCriterioPorVueloDisponible(){
//		busqueda = new Busqueda(criterioVueloDisponible)
//		var resultados = buscador.buscarVuelos(busqueda)
//		Assert.assertEquals(resultados.length, 4)
//	}
//	
//	
//	@Test
//	def void testCriterioPorConjuncion(){
//		var criterio = criterioOrigen.and(criterioNombre)
//		busqueda = new Busqueda(criterio)
//		var resultados = buscador.buscarVuelos(busqueda)
//		
//		Assert.assertEquals(resultados.length, 1)
//	}
//	@Test
//	def void testCriterioPorDisjuncion(){
//		var criterio = criterioOrigen.or(criterioDestino)
//		busqueda = new Busqueda(criterio)
//		var resultados = buscador.buscarVuelos(busqueda)
//		
//		Assert.assertEquals(resultados.length, 4)
//	}
//
//	@Test
//	def void testBuscarPorOrdenDeMenorCosto(){
//		var ordenCosto = new OrdenPorCostoDeVuelo()
//		ordenCosto.porMenorOrden
//		busqueda = new Busqueda(criterioOrigen, ordenCosto)
//		var resultados = buscador.buscarVuelos(busqueda)
//		
//		Assert.assertEquals(2, resultados.head.nroVuelo)
//	}
//	@Test
//	def void testBuscarPorOrdenMenorTrayecto(){
//		
//		var ordenTrayecto = new OrdenPorEscalas()
//		ordenTrayecto.porMenorOrden
//		busqueda = new Busqueda(criterioOrigen, ordenTrayecto)		
//		var resultados = buscador.buscarVuelos(busqueda)
//		var vuelo = resultados.head
//		
//		Assert.assertEquals(2, vuelo.nroVuelo)
//	}
//	@Test
//	def void testBuscarPorMenorDuracion(){
//		
//		
//		var ordenDuracion = new OrdenPorDuracion()
//		ordenDuracion.porMenorOrden
//		busqueda = new Busqueda(criterioOrigen, ordenDuracion)
//		var resultados = buscador.buscarVuelos(busqueda)
//		
//		Assert.assertEquals(1, resultados.get(0).nroVuelo)
//		
//	}
//	
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
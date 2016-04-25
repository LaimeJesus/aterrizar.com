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
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorOrigen
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorFechaDeLlegada
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorDestino
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorFechaDeSalida
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorCategoriaDeAsiento
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorVueloDisponible
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorDuracion
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorEscalas

/*
 * Esta clase esta para testear al servicio de reserva de asientos. Es decir integra los repositorios de Aerolinea y Busqueda.
 * Ademas de testear sus casos de uso
 */

class ServicioDeReservaDeVuelosTest {
	
	Aerolinea prueba
	Aerolinea aerolineasArgentinas

	ServicioDeReservaDeVuelos sudo
	Busqueda busqueda
	Tramo tramoEstadosUnidosArgentina
	Vuelo vuelo
	Asiento asientoLibrePrimera
	
	@Before
	def void setUp(){
		
		//nuestro system under 
		sudo = new ServicioDeReservaDeVuelos
		
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
		
		var tramoArgentinaUruguay = new Tramo("Argentina", "Uruguay", 20, '2016-05-12', '2016-05-12', 1)
		tramoArgentinaUruguay.asientosStandard()
		
		var tramoUruguayBrasil = new Tramo("Uruguay", "Brasil", 50, '2016-05-10', '2016-05-12', 2)
		tramoUruguayBrasil.asientosStandard()
		
		vueloNroUno.agregarTramo(tramoArgentinaUruguay)
		vueloNroUno.agregarTramo(tramoUruguayBrasil)
		
		//////////////////////////////////////
		//tramos vuelo 2
		//////////////////////////////////////

		
		var tramoArgentinaUSA= new Tramo("Argentina", "USA", 20, '2016-05-12', '2016-06-12', 3)
		tramoArgentinaUSA.asientosStandard()
		
		vueloNroDos.agregarTramo(tramoArgentinaUSA)
		
		//////////////////////////////////////
		//tramos vuelo 3
		//////////////////////////////////////

		
		var tramoArgentinaChile = new Tramo("Argentina", "Chile", 10, '2016-5-12', '2016-5-20', 4)
		tramoArgentinaChile.asientosStandard()
		
		var tramoChileAustralia = new Tramo("Chile", "Australia", 50, '2016-5-20', '2016-6-1', 5)
		tramoChileAustralia.asientosStandard()
		
		var tramoAustraliaJapon = new Tramo("Australia", "Japon", 30, '2016-6-1', '2016-6-12', 6)
		tramoAustraliaJapon.crearAsientos(TipoDeCategoria.BUSINESS, 5, 5)

		vueloNroTres.agregarTramo(tramoArgentinaChile)
		vueloNroTres.agregarTramo(tramoChileAustralia)
		vueloNroTres.agregarTramo(tramoAustraliaJapon)
		
		//////////////////////////////////////
		//Aerolinea prueba
		//////////////////////////////////////

		prueba = new Aerolinea("prueba")
		
		//////////////////////////////////////
		//Vuelo nro 4
		//////////////////////////////////////
		
		vuelo = new Vuelo(4)
		//////////////////////////////////////
		//tramos
		//////////////////////////////////////
		
		var tramoArgentinaBrasil = new Tramo("Argentina", "Brasil", 100, '2016-1-5', '2016-2-5', 7)
		var tramoBrasilMexico = new Tramo("Brasil", "Mexico", 200, '2016-2-5', '2016-3-5', 8)
		var tramoMexicoEstadosUnidos = new Tramo("Mexico", "USA", 100, '2016-3-5', '2016-3-6', 9)
		tramoEstadosUnidosArgentina = new Tramo("USA", "Argentina", 100, '2016-3-6', '2016-3-9', 10)
		
		//////////////////////////////////////
		//asiento ocupado
		//////////////////////////////////////

		var asientoOcupadoPrimera = new Asiento(TipoDeCategoria.PRIMERA, 50)
		var usuarioOcupantePrimera = new Usuario()
		usuarioOcupantePrimera.nickname = "pepe"
		asientoOcupadoPrimera.reservadoPorUsuario = usuarioOcupantePrimera 

		//////////////////////////////////////
		//asiento ocupado
		//////////////////////////////////////

		var asientoOcupadoBusiness = new Asiento(TipoDeCategoria.BUSINESS, 50)
		var usuarioOcupanteBusiness = new Usuario()
		usuarioOcupanteBusiness.nickname = "jose"
		asientoOcupadoBusiness.reservadoPorUsuario = usuarioOcupanteBusiness

		//////////////////////////////////////
		//asiento ocupado
		//////////////////////////////////////

		var asientoOcupadoTurista = new Asiento(TipoDeCategoria.TURISTA, 50)
		var usuarioOcupanteTurista = new Usuario()
		usuarioOcupanteTurista.nickname = "carlos"
		asientoOcupadoTurista.reservadoPorUsuario = usuarioOcupanteTurista

		//////////////////////////////////////
		//asiento desocupado
		//////////////////////////////////////

		asientoLibrePrimera = new Asiento(TipoDeCategoria.PRIMERA, 100)
		
		//////////////////////////////////////
		//agrgando asientos ocupados a tramos
		//////////////////////////////////////
		
		tramoArgentinaBrasil.agregarAsiento(asientoOcupadoPrimera)
		tramoBrasilMexico.agregarAsiento(asientoOcupadoBusiness)
		tramoMexicoEstadosUnidos.agregarAsiento(asientoOcupadoTurista)
		tramoEstadosUnidosArgentina.agregarAsiento(asientoLibrePrimera)

		//////////////////////////////////////
		//agregando tramos al vuelo
		//////////////////////////////////////
		
		vuelo.agregarTramo(tramoArgentinaBrasil)
		vuelo.agregarTramo(tramoBrasilMexico)
		vuelo.agregarTramo(tramoMexicoEstadosUnidos)
		vuelo.agregarTramo(tramoEstadosUnidosArgentina)
		
		//////////////////////////////////////
		//agregando vuelo a prueba
		//////////////////////////////////////
		
		
		prueba.agregarVuelo(vuelo)

///////////////////////////////////////////////////////////////	

		//aqui comienza el verdadero set up
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
	def void testBuscarVuelosConUnFiltroDeNombreYOrdenDeCosto(){
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
	 
	@Test
	def void testBuscarVuelosPorUnFiltroComplicado(){
		
		/*
		 *		origen USA y destino Argentina y llegaada 2016-5-20 
		 * 		or
		 * 		(salida 2016-5-20 o categoria de asiento Turista
		 * 		and
		 * 		nombre Aerolineas Argentinas y vuelos disponibles)
		 * 
		 * 		esto es igual a todos los vuelos de aerolineaas argentinas
		 */

		
		var unFiltro = new CriterioPorOrigen("USA").and(new CriterioPorDestino("Argentina").and(new CriterioPorFechaDeLlegada('2016-5-20')))
		var otroFiltro = new CriterioPorFechaDeSalida('2016-5-20').or(new CriterioPorCategoriaDeAsiento(TipoDeCategoria.TURISTA))
		var ultimoFiltro = new CriterioPorNombreDeAerolinea("Aerolineas Argentinas").and(new CriterioPorVueloDisponible)
		
		var filtro = unFiltro.or(otroFiltro.and(ultimoFiltro))
		busqueda = new Busqueda(filtro)
		var resultados = sudo.buscar(busqueda)
		
		Assert.assertEquals(3, resultados.length)
	}
	
	@Test
	def void testBuscarVuelosYOrdenarlos(){
		
		var ordenDuracion = new OrdenPorDuracion()
		var ordenEscala = new OrdenPorEscalas()
		var ordenCosto = new OrdenPorCostoDeVuelo()
		var orden = ordenCosto.and(ordenDuracion).and(ordenEscala)
		orden.porMenorOrden
		busqueda = new Busqueda(orden)
		var resultados = sudo.buscar(busqueda)
		
		//verificar al vuelo con menor duracion, menor escala y menor costo
		Assert.assertEquals(2, resultados.head.nroVuelo)
	}
	
	@Test
	def void testVolverARealizarUltimaConsultaDeberiaDarmeUnaBusquedaConIdMayorA1(){
		
		//esto va cambiando ya que despues de cada test se vuelve a crear una busqueda con un nuevo id
		
		var ordenEscala = new OrdenPorEscalas()
		busqueda = new Busqueda(ordenEscala)
		sudo.buscar(busqueda)
		var busquedas = sudo.busquedas
		var ultimaBusqueda = sudo.ultimaBusqueda
		
		//buscando maximo deberia usar fold o algo mejorcito
		var max = ultimaBusqueda
		for(Busqueda b : busquedas){
			if(b.idBusqueda > max.idBusqueda){
				max = b
			}
		}
		System.out.println(ultimaBusqueda.idBusqueda)
		System.out.println("es mayor que")
		System.out.println(max.idBusqueda)
		Assert.assertTrue(ultimaBusqueda.idBusqueda >= max.idBusqueda)
	}
	
	@Test
	def void testReservarUnAsientoDisponiblePorUnUsuarioLoActualiza(){
		var usuarioPepe = new Usuario()
		usuarioPepe.nickname = "jesus"
		var asientoReservado = sudo.reservar(usuarioPepe, prueba, vuelo , tramoEstadosUnidosArgentina, asientoLibrePrimera)
		
		//prueba que asiento esta reservado
		Assert.assertTrue(asientoReservado.reservadoPorUsuario != null)
		
		//prueba que sea el usuario correcto
		Assert.assertEquals(usuarioPepe, asientoReservado.reservadoPorUsuario)
	}
	
	@After
	def void testEliminarAerolineasYBusquedas(){
		
		sudo.eliminarAerolinea(prueba)
		sudo.eliminarAerolinea(aerolineasArgentinas)
		sudo.eliminarBusquedas()
	}

}
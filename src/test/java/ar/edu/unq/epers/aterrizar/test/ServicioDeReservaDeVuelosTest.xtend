package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.After
import org.junit.Test
import org.junit.Assert
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeReservaDeVuelos
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.vuelos.Aerolinea
import ar.edu.unq.epers.aterrizar.domain.vuelos.Tramo
import ar.edu.unq.epers.aterrizar.domain.vuelos.Vuelo
import ar.edu.unq.epers.aterrizar.domain.vuelos.Asiento

/*
 * Esta clase esta para testear al servicio de reserva de asientos. Es decir integra los repositorios de Aerolinea y Busqueda.
 * Ademas de testear sus casos de uso
 */

class ServicioDeReservaDeVuelosTest {
	
	Aerolinea prueba
	Aerolinea aerolineasArgentinas

	ServicioDeReservaDeVuelos sudo
	Tramo tramoEstadosUnidosArgentina
	Vuelo vuelo
	Asiento asientoLibrePrimera
	Usuario usuario
	
	Asiento asientoOcupadoTurista
	
	Tramo tramoMexicoEstadosUnidos
	
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
//		tramoArgentinaUruguay.asientosStandard()
		
		var tramoUruguayBrasil = new Tramo("Uruguay", "Brasil", 50, '2016-05-10', '2016-05-12', 2)
//		tramoUruguayBrasil.asientosStandard()
		
		vueloNroUno.agregarTramo(tramoArgentinaUruguay)
		vueloNroUno.agregarTramo(tramoUruguayBrasil)
		
		//////////////////////////////////////
		//tramos vuelo 2
		//////////////////////////////////////

		
		var tramoArgentinaUSA= new Tramo("Argentina", "USA", 20, '2016-05-12', '2016-06-12', 3)
//		tramoArgentinaUSA.asientosStandard()
		
		vueloNroDos.agregarTramo(tramoArgentinaUSA)
		
		//////////////////////////////////////
		//tramos vuelo 3
		//////////////////////////////////////

		
		var tramoArgentinaChile = new Tramo("Argentina", "Chile", 10, '2016-5-12', '2016-5-20', 4)
//		tramoArgentinaChile.asientosStandard()
		
		var tramoChileAustralia = new Tramo("Chile", "Australia", 50, '2016-5-20', '2016-6-1', 5)
//		tramoChileAustralia.asientosStandard()
		
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
		tramoMexicoEstadosUnidos = new Tramo("Mexico", "USA", 100, '2016-3-5', '2016-3-6', 9)
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

		asientoOcupadoTurista = new Asiento(TipoDeCategoria.TURISTA, 50)
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
		
		usuario = new Usuario
		usuario.nickname = "Pepe"
		
	}
	
	@Test
	def void testCrearAerolineaParaProbarBaseDeDatos(){
		var existeAerolienas = sudo.existeAerolinea(aerolineasArgentinas)
		var existePrueba = sudo.existeAerolinea(prueba)
		
		Assert.assertEquals(true, existeAerolienas)
		Assert.assertEquals(true, existePrueba)
	}
	
	@Test
	def void testReservarUnAsientoDisponiblePorUnUsuarioLoReserva(){
		
		var unUsuario = usuario
		var unaAerolinea = prueba
		var unVuelo = vuelo
		var unTramo = tramoEstadosUnidosArgentina
		var unAsiento = asientoLibrePrimera
			
		var asientoReservado = sudo.reservar(unUsuario, unaAerolinea, unVuelo , unTramo, unAsiento)
		
		//prueba que asiento esta reservado
		Assert.assertTrue(asientoReservado.isReservado)
		
		//prueba que sea el usuario correcto
		Assert.assertEquals(unUsuario, asientoReservado.reservadoPorUsuario)
	}
	
//	no me deja esperar esa excepcion en el test
//	@Test(expected=AsientoReservadoException)
	@Test(expected=Exception)
	def void testReservarUnAsientoExceptionPorUnUsuario(){

		var pepe = usuario
	
		var asientoReservado = sudo.reservar(pepe, prueba , vuelo , tramoMexicoEstadosUnidos, asientoOcupadoTurista)

		//veo que el asiento este reservado		
		Assert.assertTrue(asientoReservado.reservado)
		//veo que los id sean diferentes
		Assert.assertNotEquals(asientoReservado.reservadoPorUsuario.idUsuario, pepe.idUsuario)
		//prueba que sea el usuario correcto
		Assert.assertNotEquals(pepe, asientoOcupadoTurista.reservadoPorUsuario)
	}
	
	@After
	def void testEliminarAerolineasYBusquedas(){
		
		sudo.eliminarAerolinea(prueba)
		sudo.eliminarAerolinea(aerolineasArgentinas)
		
	}

}
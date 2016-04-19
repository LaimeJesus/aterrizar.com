package ar.edu.unq.epers.aterrizar.test

import ar.edu.unq.epers.aterrizar.servicios.ServicioDeReservaDeVuelos
import org.junit.Test
import org.junit.Before
import ar.edu.unq.epers.aterrizar.domain.buscador.criterios.CriterioPorOrigen
import ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda
import org.junit.Assert

class ServicioDeReservaDeVuelosTest {
	
	ServicioDeReservaDeVuelos sudo
	CriterioPorOrigen origenArgentina
	Busqueda busqueda
	
	@Before
	def void setUp(){
		sudo = new ServicioDeReservaDeVuelos
		origenArgentina = new CriterioPorOrigen("Argentina")
		busqueda = new Busqueda(origenArgentina)
	}
	
	@Test
	def void testBuscarVuelosActualizaLasBusquedasRealizadas(){
		var busquedaPrima = sudo.ordenarPorMenorDuracion(busqueda)
		
		var vuelos = sudo.buscar(busquedaPrima)
		
		Assert.assertEquals(0, vuelos.size)
	}
}
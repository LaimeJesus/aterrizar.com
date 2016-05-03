package ar.edu.unq.epers.aterrizar.domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import java.sql.Date
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria
import ar.edu.unq.epers.aterrizar.exceptions.AsientoNoExisteException

@Accessors

class Tramo {
	int nroTramo
	int idTramo
	String destino
	String origen
	List<Asiento> asientos
	int precioBase

	Date fechaDeSalida
	Date fechaDeLlegada
	
	long duracionDeTramo
	
	new(){
	}
	
	new(String from, String to, int precio, String salida, String llegada){
		origen = from
		destino = to
		asientos = new ArrayList<Asiento>()
		precioBase = precio
		fechaDeSalida = Date.valueOf(salida)
		fechaDeLlegada = Date.valueOf(llegada)
		duracionDeTramo = fechaDeLlegada.time - fechaDeSalida.time
	}
	//no me deja usar new con los parametros de arriba, entiendo que estoy repitiendo codigo 
	new(String from, String to, int precio, String salida, String llegada, int numeroTramo){
		nroTramo = numeroTramo
		origen = from
		destino = to
		asientos = new ArrayList<Asiento>()
		precioBase = precio
		fechaDeSalida = Date.valueOf(salida)
		fechaDeLlegada = Date.valueOf(llegada)
		duracionDeTramo = fechaDeLlegada.time - fechaDeSalida.time
	}
	
	def calcularPrecioDeUnAsiento(Asiento unAsiento){
		return precioBase + unAsiento.precio()
	}
	
	def calcularCostoTotal(){
		var costo = 0.0
		for(Asiento a: asientos){
			costo = costo + this.calcularPrecioDeUnAsiento(a)
		}
		return costo
		
	}
	
	def getAsientosDisponibles(){
		var disponibles = new ArrayList<Asiento>()
		for(Asiento a : asientos){
			if(!a.isReservado()){
				disponibles.add(a)
			}
		}
		return disponibles
	}
	
	def isDisponible(){
		return this.getAsientosDisponibles().length()>0
	}
	
	def void asientosStandard(){

		//creo los asientos business
		crearAsientos(TipoDeCategoria.BUSINESS, 20, 15)
		//creo los asientos turista
		crearAsientos(TipoDeCategoria.TURISTA, 50, 10)
		//creo los asientos primera
		crearAsientos(TipoDeCategoria.PRIMERA, 100, 5)
		
		
	}
	
	//solo usado en tests
	
	def crearAsientos(TipoDeCategoria categoria, int precio, int cantidadDeAsientos) {
		var cantidad = cantidadDeAsientos
		
		//mejor manera de hacerlo seria con un for
		while(cantidad >= 0){
			asientos.add(new Asiento(categoria, precio))
			cantidad -= 1
		}
	}
	
	def agregarAsiento(Asiento asiento) {
		asientos.add(asiento)
	}
	
	def removerAsiento(Asiento asiento) {
		asientos.remove(asiento)
	}
	
	def contieneAsiento(Asiento asiento){
		asientos.exists[it.equals(asiento)]
	}
	
	def equals(Tramo t){
		return nroTramo.equals(t.nroTramo)
	}
	def void validarReserva(Asiento asiento) throws AsientoNoExisteException{

		if(!contieneAsiento(asiento)){
			throw new AsientoNoExisteException("no existe el asiento con nro " + asiento.nroAsiento.toString)
		}
		asiento.validarReserva()
	}
	
}
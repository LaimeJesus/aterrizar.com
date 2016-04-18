package ar.edu.unq.epers.aterrizar.domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import java.sql.Date
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria

@Accessors

class Tramo {
	int idTramo
	String destino
	String origen
	List<Asiento> asientos
	float precioBase

	Date fechaDeSalida
	Date fechaDeLlegada
	
	new(){
		
	}
	
	new(String from, String to, int precio, String salida, String llegada){
		origen = from
		destino = to
		asientos = new ArrayList<Asiento>()
		precioBase = precio
		fechaDeSalida = Date.valueOf(salida)
		fechaDeLlegada = Date.valueOf(llegada)
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
		var asientosBusiness = crearAsientos(TipoDeCategoria.BUSINESS, 20, 15)

		//creo los asientos turista
		var asientosTurista = crearAsientos(TipoDeCategoria.TURISTA, 50, 10)
		
		//creo los asientos primera
		var asientosPrimera = crearAsientos(TipoDeCategoria.PRIMERA, 100, 5)
		
		asientos.addAll(asientosBusiness)
		asientos.addAll(asientosTurista)
		asientos.addAll(asientosPrimera)
		
	}
	
	def crearAsientos(TipoDeCategoria categoria, int precio, int cantidadDeAsientos) {
		var asientos = new ArrayList<Asiento>()
		var cantidad = cantidadDeAsientos
		while(cantidad != 0){
			asientos.add(new Asiento(categoria, precio))
			cantidad -= 1
		}
		return asientos
	}
	
}
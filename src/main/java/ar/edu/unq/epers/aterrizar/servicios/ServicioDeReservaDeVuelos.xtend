package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import ar.edu.unq.epers.aterrizar.domain.Tramo
import ar.edu.unq.epers.aterrizar.domain.Asiento
import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea
import java.util.List
import ar.edu.unq.epers.aterrizar.domain.buscador.Busqueda
import ar.edu.unq.epers.aterrizar.domain.buscador.BuscadorDeVuelos
import ar.edu.unq.epers.aterrizar.persistence.RepositorioBusquedas
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorCostoDeVuelo
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorTrayecto
import ar.edu.unq.epers.aterrizar.domain.buscador.ordenes.OrdenPorDuracion
import ar.edu.unq.epers.aterrizar.exceptions.ReservarException
import ar.edu.unq.epers.aterrizar.persistence.SessionManager

class ServicioDeReservaDeVuelos {
	
	//Nuestro sistema de reserva de asientos
	

	RepositorioAerolinea repositorioDeAerolineas = new RepositorioAerolinea
	BuscadorDeVuelos buscador = new BuscadorDeVuelos(repositorioDeAerolineas)
	RepositorioBusquedas repositorioDeBusquedas = new RepositorioBusquedas
	
	def void reservar(Usuario usuario, Aerolinea unaAerolinea, Vuelo unVuelo, Tramo unTramo, Asiento unAsiento){
		
		var aerolineaFromRepo = this.traerAerolinea(unaAerolinea)
		var vuelos = aerolineaFromRepo.vuelos
		
		//no estoy seguro pero creo que esto funcionaria asi
		if(vuelos.contains(unVuelo)){
			var tramos = unVuelo.tramos
			if(tramos.contains(unTramo)){
				var asientos = unTramo.asientos
				if(asientos.contains(unAsiento)){
					if(!unAsiento.isReservado){
						unAsiento.reservarPor(usuario)
						this.actualizarReservas(aerolineaFromRepo)
					}
					else{
						throw new ReservarException("asiento reservado")
					}
				}
				else{
					throw new ReservarException("asiento no pertenece a ese tramo")
				}

			}
			else{
				throw new ReservarException("ese tramo no pertenece a ese vuelo")
				}
			
		}
		else{
			throw new ReservarException("ese vuelo no pertenece a esa aerolinea")
		}
	}
	
	def List<Vuelo> buscar(Busqueda b){
		var	resultado =	buscador.buscarVuelos(b)
		
		guardar(b)
		
		return resultado
	}
	

	def List<Asiento> consultarAsientos(Tramo t){
		return t.asientosDisponibles
	}
	
	def Busqueda getUltimaBusqueda(){
		var resultado = SessionManager.runInSession([
		repositorioDeBusquedas.traerPorId
		])
		return resultado
	}

	def void guardar(Busqueda b){
		SessionManager.runInSession([
			repositorioDeBusquedas.persistir(b)
			null
		])
	}

	def Busqueda ordenarPorMenorCosto(Busqueda b){
		var menorCosto = new OrdenPorCostoDeVuelo
		menorCosto.porMenorOrden 
		b.ordenarPor(menorCosto)
		return b
		}
	def Busqueda ordenarPorMenorEscala(Busqueda b){
		var menorTrayecto = new OrdenPorTrayecto
		menorTrayecto.porMenorOrden 

		b.ordenarPor(menorTrayecto)
		return b
	}
	def Busqueda ordenarPorMenorDuracion(Busqueda b){
		var menorDuracion = new OrdenPorDuracion
		menorDuracion.porMenorOrden 

		b.ordenarPor(menorDuracion)
		return b
	}

	def actualizarReservas(Aerolinea aerolinea) {
		this.actualizarAerolinea(aerolinea)
	}
	
	def actualizarAerolinea(Aerolinea aerolinea) {
		SessionManager.runInSession([
			repositorioDeAerolineas.actualizar(aerolinea, "nombreAerolinea", aerolinea.nombreAerolinea)
			null
		])
	}
 	def Aerolinea traerAerolinea(Aerolinea unaAerolinea){
 		
 		var resultado = SessionManager.runInSession([
 			repositorioDeAerolineas.traer("nombreAerolinea", unaAerolinea.nombreAerolinea)
 			])
 		return resultado
 	}
 	def eliminarAerolinea(Aerolinea unaAero){
 		SessionManager.runInSession[|
 			repositorioDeAerolineas.borrar("nombreAerolinea", unaAero.nombreAerolinea)
 			null
 		]
 	}
}
package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.Aerolinea
import ar.edu.unq.epers.aterrizar.domain.Vuelo
import ar.edu.unq.epers.aterrizar.domain.Tramo
import ar.edu.unq.epers.aterrizar.domain.Asiento
import ar.edu.unq.epers.aterrizar.persistence.RepositorioAerolinea

class ServicioDeRegistroDeVuelos {
	
	//Nuestro sistema de reserva de asientos
	

	RepositorioAerolinea repositorioDeAerolineas
	
	def void reservar(Usuario usuario, Aerolinea unaAerolinea, Vuelo unVuelo, Tramo unTramo, Asiento unAsiento){
		var aerolineaFromRepo = this.traerAerolineaPorNombre(unaAerolinea)
		var vuelos = aerolineaFromRepo.vuelos
		
		//no estoy seguro pero creo que esto funcionaria asi
		if(vuelos.contains(unVuelo)){
			var tramos = unVuelo.tramos
			if(tramos.contains(unTramo)){
				var asientos = unTramo.asientos
				if(asientos.contains(unAsiento)){
					if(!unAsiento.isReservado){
						unAsiento.reservadoPorUsuario = usuario
						this.actualizarReservas(aerolineaFromRepo)
					}
					else{
						throw new Exception("asiento reservado")
					}
				}
				else{
					throw new Exception("asiento no pertenece a ese tramo")
				}

			}
			else{
				throw new Exception("ese tramo no pertenece a ese vuelo")
				}
			
		}
		else{
			throw new Exception("ese vuelo no pertenece a esa aerolinea")
		}
	}
	
	def actualizarReservas(Aerolinea aerolinea) {
		this.actualizarAerolineaPorNombre(aerolinea)
	}
	
	def actualizarAerolineaPorNombre(Aerolinea aerolinea) {
		repositorioDeAerolineas.actualizar(aerolinea, "nombreAerolinea", aerolinea.nombreAerolinea)
	}
	
/*
	def List<Asiento> consultarAsientos(Tramo t){}
	def List<Busqueda> buscar(CriterioDeBusqueda c){}
	def void guardar(){}
	def List<Busqueda> ordenarPorMenorCosto(){}
	def List<Busqueda> ordenarPorMenorEscala(){}
	def List<Busqueda> ordenarPorMenorDuracion(){}
*/
 
 	def Aerolinea traerAerolineaPorNombre(Aerolinea unaAerolinea){
 		return repositorioDeAerolineas.traer("nombreAerolinea", unaAerolinea.nombreAerolinea)
 	}
}
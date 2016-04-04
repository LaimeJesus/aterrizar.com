package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Reserva {
	int idReserva 
	Usuario usuario
	Tramo tramo
	Asiento asiento
}
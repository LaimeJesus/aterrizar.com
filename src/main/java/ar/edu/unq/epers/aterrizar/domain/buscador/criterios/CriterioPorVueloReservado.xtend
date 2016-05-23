package ar.edu.unq.epers.aterrizar.domain.buscador.criterios

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.Usuario

@Accessors
class CriterioPorVueloReservado extends Criterio{
	
	String nickname
	
	new(Usuario u){
		nickname = u.nickname
	}
	
	override getCondicion() {
		return "asientos.reservadoPorUsuario.nickname = nickname"
	}
}
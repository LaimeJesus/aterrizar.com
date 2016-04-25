package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.categorias.TipoDeCategoria

@Accessors

class Asiento {
	TipoDeCategoria categoria
	int idAsiento
	Usuario reservadoPorUsuario
	int nroAsiento
	
	new(){
		
	}
	
	new(TipoDeCategoria cat, int precioCat){
		reservadoPorUsuario = null
		cat.factorPrecio = precioCat
		categoria = cat
	}
	//no me deja usar new con los parametros de arriba, entiendo que estoy repitiendo codigo 
	new(TipoDeCategoria cat, int precioCat, int numeroAsiento){
		reservadoPorUsuario = null
		cat.factorPrecio = precioCat
		categoria = cat
		nroAsiento = numeroAsiento
	}
	def isReservado(){
		return reservadoPorUsuario != null
	}
	
	def precio() {
		return categoria.factorPrecio
	}
	
	def reservar(Usuario usuario) {
		reservadoPorUsuario = usuario
	}
	
	def equals(Asiento a){
		return nroAsiento.equals(a.nroAsiento)
	}
	
}
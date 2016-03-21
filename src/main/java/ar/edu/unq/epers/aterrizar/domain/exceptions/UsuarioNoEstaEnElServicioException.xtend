package ar.edu.unq.epers.aterrizar.domain.exceptions

import ar.edu.unq.epers.aterrizar.domain.Usuario

class usuarioNoEstaEnElServicioException extends Exception{
	
	new(Usuario usr){
		super(usr.nickname + 'is not in the repo')
	}
	
}
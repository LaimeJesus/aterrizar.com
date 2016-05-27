package ar.edu.unq.epers.aterrizar.exceptions

import ar.edu.unq.epers.aterrizar.domain.mensajes.Mail

class EnviarMailException extends Exception{
	new(Mail m){
		super("enviado por " + m.from + " a " + m.to)
	}
}
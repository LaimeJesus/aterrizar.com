package ar.edu.unq.epers.aterrizar.exceptions


class EnviarMailException extends Exception{
	new(ar.edu.unq.epers.aterrizar.domain.Mail m){
		super("enviado por " + m.from + " a " + m.to)
	}
}
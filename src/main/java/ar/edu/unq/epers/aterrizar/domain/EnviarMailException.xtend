package ar.edu.unq.epers.aterrizar.domain


class EnviarMailException extends Exception{
	new(Mail m){
		super("enviado por " + m.from + " a " + m.to)
	}
}
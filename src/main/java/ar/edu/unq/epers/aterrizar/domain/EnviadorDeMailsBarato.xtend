package ar.edu.unq.epers.aterrizar.domain


class EnviadorDeMailsBarato implements EnviadorDeMails{
	
	override void enviarMail(Mail m){
		new EnviarMailException(m)
	}
	
}
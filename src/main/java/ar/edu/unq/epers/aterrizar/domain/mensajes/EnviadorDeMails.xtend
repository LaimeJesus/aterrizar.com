package ar.edu.unq.epers.aterrizar.domain.mensajes


interface EnviadorDeMails {
	def void enviarMail(Mail m)
}
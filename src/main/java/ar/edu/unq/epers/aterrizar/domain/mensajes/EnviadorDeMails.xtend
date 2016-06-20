package ar.edu.unq.epers.aterrizar.domain.mensajes

import ar.edu.unq.epers.aterrizar.exceptions.EnviarMailException

interface EnviadorDeMails {
	def void enviarMail(Mail m) throws EnviarMailException
}
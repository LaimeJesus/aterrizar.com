package ar.edu.unq.epers.aterrizar.domain.mensajes

import ar.edu.unq.epers.aterrizar.domain.Usuario

class CreadorDeMails {
	
	def crearMailParaUsuario(String from, Usuario usuario, String codigo) {
		val mail = new Mail()
		mail.from = 'servicioDeRegistroDeMails'
		mail.to = usuario.email
		mail.body = codigo
		mail.subject = 'Codigo a validar'
		return mail
	}
}
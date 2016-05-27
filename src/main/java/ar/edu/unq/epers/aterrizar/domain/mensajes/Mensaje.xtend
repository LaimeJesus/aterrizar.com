package ar.edu.unq.epers.aterrizar.domain.mensajes

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Mensaje {
	String emisor
	String receptor
	String body
	String subject
	Integer idMensaje
}
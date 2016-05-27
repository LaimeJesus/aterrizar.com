package ar.edu.unq.epers.aterrizar.domain.mensajes

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Mail {
	String body
	String subject
	String to
	String from
	Integer idMail
}
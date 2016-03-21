package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Date
import java.util.List

@Accessors
class Usuario {
	String nombre
	String apellido
	String nickname
	String password
	String email
	Date fechaDeNacimiento
	List<main.java.ar.edu.unq.epers.aterrizar.domain.Mail> emails
	
}
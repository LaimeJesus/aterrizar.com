package main.java.ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Date
import java.util.List

class Usuario {
	@Accessors
	String nombre
	@Accessors	
	String apellido
	@Accessors
	String nickname
	@Accessors
	String password
	@Accessors
	String email
	@Accessors
	Date fechaDeNacimiento
	@Accessors
	List<Mail> emails
	
}
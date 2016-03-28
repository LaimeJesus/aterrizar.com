package ar.edu.unq.epers.aterrizar.domain

import java.sql.Date
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Usuario {
	String nombre
	String apellido
	String nickname
	String password
	String email
	Date fechaDeNacimiento
	ArrayList<Mail> emails
	String codigo
	
}
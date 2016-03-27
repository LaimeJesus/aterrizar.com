package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.sql.Date

@Accessors
class Usuario {
	int id = 0
	String nombre
	String apellido
	String nickname
	String password
	String email
	Date fechaDeNacimiento
	List<Mail> emails
	String codigo
	
	def estaValidado(){
		return codigo.equals('usado')
	}
	
}
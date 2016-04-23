package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.sql.Date

@Accessors
class Usuario {
	int idUsuario
	String nombre
	String apellido
	String nickname
	String password
	String email
	Date fechaDeNacimiento
	String codigo
	
	new(){
		
	}
	
	def estaValidado(){
		return codigo.equals('usado')
	}
	
	def validarCodigo(){
		codigo = 'usado'
	}
	
}
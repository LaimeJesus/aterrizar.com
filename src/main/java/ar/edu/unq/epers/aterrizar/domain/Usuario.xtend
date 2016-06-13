package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.sql.Date
import ar.edu.unq.epers.aterrizar.exceptions.MyValidateException

@Accessors
class Usuario {
	int idUsuario
	String nombre
	String apellido
	String nickname
	String password
	String email
	String codigo
	Date fechaDeNacimiento
	
	new() {
	}

	def estaValidado() {
		return codigo.equals('usado')
	}

	def usarCodigo() {
		codigo = 'usado'
	}

	def validarCodigo(String code) throws MyValidateException{
		if(!this.codigo.equals(code)) {
			errorUsuario('codigo incorrecto')
		}
	}

	def isValidadoCodigo() throws MyValidateException{
		if(this.estaValidado()) {
			errorUsuario('codigo de validacion usado')
		}
	}

	def validarPassword(String pass) throws MyValidateException{
		if(!this.password.equals(pass)) {
			errorUsuario('password erroneo')
		}
	}

	def validarCambioPassword(String nwpass) throws MyValidateException{
		if(password.equals(nwpass)) {
			errorUsuario('nwpass is the same that previous password')
		}
	}

	def errorUsuario(String msg) throws MyValidateException{
		throw new MyValidateException(msg)
	}

}

package ar.edu.unq.epers.aterrizar.domain

import ar.edu.unq.epers.aterrizar.domain.exceptions.ChangingPasswordException
import ar.edu.unq.epers.aterrizar.domain.exceptions.MyLoginException
import ar.edu.unq.epers.aterrizar.domain.exceptions.MyValidateException
import ar.edu.unq.epers.aterrizar.domain.exceptions.RegistrationException
import ar.edu.unq.epers.aterrizar.persistence.RepositorioUsuario
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RecorderService {
	
	RepositorioUsuario repositorio
	CreadorDeCodigos creadorDeCodigos
	EnviadorDeMails enviadorDeMails
	int ids
	CreadorDeMails creadorDeMails
	
	new(){
		//id este es un numero de unico por usuario. Es solo para una prueba
		ids = 1
		repositorio = new RepositorioUsuario()
	}
	
	def registrarUsuario(Usuario usr) throws Exception{
		if(this.contieneUsuarioPorNickname(usr.nickname)){
			new RegistrationException('Nickname is being used')
		}
		else{
			usr.id = ids
			ids = ids + 1
			
			this.nuevoUsuarioEnElSistema(usr)
		}
	}
	
	def validar(Usuario usr, String codigo) throws Exception{
		val usuarioAValidar = this.traerUsuarioPorNickname(usr.nickname)
		
		//! codigo.equals('usado')
		if(usuarioAValidar.codigo.equals(codigo)){
			usuarioAValidar.codigo = 'usado'
			this.actualizarUsuarioPorNickname(usuarioAValidar)
		}
		else{
			new MyValidateException('codigo de validacion erroneo')
		}		
	}
	
	def login(String nickname, String password) throws Exception{
		val usuarioFromRepo = this.traerUsuarioPorNickname(nickname)
			if(usuarioFromRepo.password.equals(password)){
				return usuarioFromRepo
			}
			else{
				new MyLoginException("password doesn't match")
			}
	}
	
	def changePassword(Usuario usr, String newpassword) throws Exception{
		
		val usuarioACambiarPassword = this.traerUsuarioPorNickname(usr.nickname)
		if(usuarioACambiarPassword.password.equals(newpassword))
		{
			new ChangingPasswordException('newpassword is the same that previous password')
		}
		else
		{
			usuarioACambiarPassword.password = newpassword
			repositorio.actualizar(usuarioACambiarPassword, 'nickname', usuarioACambiarPassword.nickname)	
		}
	}
	
	def traerUsuarioDelRepositorio(String field, String value) throws Exception{
		if(repositorio.contiene(field, value)){
			return repositorio.traer(field, value)
		}
		else{
			repositorio.objectNotFoundError()
		}
	}
	
	def contieneUsuarioPorNickname(String nickname){
		return repositorio.contiene('nickname', nickname)
	}
	
	def traerUsuarioPorNickname(String nickname) throws Exception{
		return this.traerUsuarioDelRepositorio('nickname', nickname)
	}
	
	def nuevoUsuarioEnElSistema(Usuario usuario) {
		repositorio.persistir(usuario)
		this.avisarNuevoUsuarioRegistrado(usuario)
	}
	
	def avisarNuevoUsuarioRegistrado(Usuario usuario) {

		val codigo = creadorDeCodigos.crearCodigo()
		val mailAEnviar = creadorDeMails.crearMailParaUsuario('registrador', usuario, codigo)
		enviadorDeMails.enviarMail(mailAEnviar)
	}
	def actualizarUsuarioPorNickname(Usuario usuario) {
		repositorio.actualizar(usuario,'nickname', usuario.nickname)
	}
	
}


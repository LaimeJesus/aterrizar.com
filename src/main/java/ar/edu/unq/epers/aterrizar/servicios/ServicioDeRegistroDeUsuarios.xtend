package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.exceptions.RegistrationException
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.CreadorDeCodigos
import ar.edu.unq.epers.aterrizar.domain.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.domain.CreadorDeMails
import ar.edu.unq.epers.aterrizar.persistence.jdbc.Repositorio
import ar.edu.unq.epers.aterrizar.persistence.jdbc.RepositorioUsuario

@Accessors
class ServicioDeRegistroDeUsuarios {
	
	Repositorio<Usuario> repositorio
	CreadorDeCodigos creadorDeCodigos
	EnviadorDeMails enviadorDeMails
	CreadorDeMails creadorDeMails
	ServicioDeAmigos servicioDeAmigos
	ServicioDePerfiles servicioDePerfiles
	
	new(){
		repositorio = new RepositorioUsuario()
		servicioDeAmigos = new ServicioDeAmigos(this)
		servicioDePerfiles = new ServicioDePerfiles(this)
	}
	
	def registrarUsuario(Usuario usr) throws Exception{
		if(this.contieneUsuarioPorNickname(usr.nickname)){
			throw new RegistrationException('Nickname is being used')
		}
		else{
			this.nuevoUsuarioEnElSistema(usr)
		}
	}
	
	def validar(Usuario usr, String codigo) throws Exception{
		
		val usuarioAValidar = this.traerUsuarioPorNickname(usr.nickname)
		
		//si el codigo ya esta usado, entonces arroja una exc
		usuarioAValidar.isValidadoCodigo()
		//si el codigo que tiene el usuario es difierente a codigo, entonces arroja una exc
		usuarioAValidar.validarCodigo(codigo)
		//cambia code a usado
		usuarioAValidar.usarCodigo()
		this.actualizarUsuarioPorNickname(usuarioAValidar)

	}
	
	def login(String nickname, String password) throws Exception{
		val usuarioFromRepo = this.traerUsuarioPorNickname(nickname)
		//ve que este validado
		usuarioFromRepo.validarCodigo(this.codigoUsado())
		//valida la password
		usuarioFromRepo.validarPassword(password)
		return usuarioFromRepo
	}
	
	def codigoUsado() {
		'usado'
	}
	
	def changePassword(Usuario usr, String newpassword) throws Exception{
		
		val usuarioACambiarPassword = this.traerUsuarioPorNickname(usr.nickname)
		usuarioACambiarPassword.validarCambioPassword(newpassword)
		usuarioACambiarPassword.password = newpassword
		repositorio.actualizar(usuarioACambiarPassword, 'nickname', usuarioACambiarPassword.nickname)	
	}
	
	////////////////////////////////////////////
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
		
		//a mi nuevo servicio de amigos le digo que lo agregue al usuario
		servicioDeAmigos.crearUsuarioDeAmigos(usuario)
		servicioDePerfiles.crearPerfil(usuario)
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
	
	def void eliminarUsuario(Usuario u){
		repositorio.borrar("nickname", u.nickname)
		servicioDePerfiles.eliminarPerfil(u)
//		servicioDeAmigos.eliminarMailsDeUsuario(u)
	}
	
	def isRegistrado(Usuario usuario) {
		if(!contieneUsuarioPorNickname(usuario.nickname)){
			repositorio.objectNotFoundError()
		}
	}
	
}
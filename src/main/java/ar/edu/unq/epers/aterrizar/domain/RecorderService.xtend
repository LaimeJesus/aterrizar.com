package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.Repositorio
import ar.edu.unq.epers.aterrizar.persistence.RepositorioUsuario
import ar.edu.unq.epers.aterrizar.domain.exceptions.RegistrationException
import ar.edu.unq.epers.aterrizar.domain.exceptions.MyLoginException
import ar.edu.unq.epers.aterrizar.domain.exceptions.ChangingPasswordException
import java.util.List
import ar.edu.unq.epers.aterrizar.domain.exceptions.MyValidateException

@Accessors
class RecorderService {
	
	Repositorio<Usuario> repositorio
// esto no va a estar
	List<Usuario> usuarios
	CreadorDeCodigos creadorDeCodigos
	EnviadorDeMails enviadorDeMails
	
	new(){
		/* 
		usuarios = new ArrayList<Usuario>()
		creadorDeCodigos = new CreadorDeCodigosBarato()
		enviadorDeMails = new EnviadorDeMailsBarato()
		*/
		repositorio = new RepositorioUsuario()
	}
	
	def registrarUsuario(Usuario usr) throws Exception{
		if(repositorio.contiene(usr, 'nickname', usr.nickname)){
			new RegistrationException('Nickname is being used')
		}
		else{
			this.nuevoUsuarioEnElSistema(usr)
		}
	}
	
	def nuevoUsuarioEnElSistema(Usuario usuario) {
		repositorio.persistir(usuario)
		this.avisarNuevoUsuarioRegistrado(usuario)
	}
	
	def avisarNuevoUsuarioRegistrado(Usuario usuario) {

		val codigo = creadorDeCodigos.crearCodigo()
		val mailAEnviar = crearMailParaUsuario(usuario, codigo)
		enviadorDeMails.enviarMail(mailAEnviar)
	}
	
	def crearMailParaUsuario(Usuario usuario, String codigo) {
		val mail = new Mail()
		mail.from = 'servicioDeRegistroDeMails'
		mail.to = usuario.email
		mail.body = codigo
		mail.subject = 'Codigo a validar'
		return mail
	}
	
	def validar(Usuario usr, String codigo) throws Exception{
		val usuarioAValidar = this.traerUsuarioPorNickname(usr, usr.nickname)
		if(usuarioAValidar.codigo.equals(codigo)){
			usuarioAValidar.codigo = 'usado'
			repositorio.actualizar(usuarioAValidar, 'codigo', codigo)
		}
		else{
			new MyValidateException('codigo de validacion usado')
		}		
	}
	
	def login(String nickname, String password) throws Exception{
				
		val usuarioFromRepo = this.traerUsuarioPorNickname(new Usuario, nickname)
			if(usuarioFromRepo.password.equals(password)){
				return usuarioFromRepo
			}
			else{
				new MyLoginException("password doesn't match")
			}
	}
	
	def traerUsuarioDelRepositorio(Usuario usr, String field, String value) throws Exception{
		if(repositorio.contiene(usr, field, value)){
			return repositorio.traer(usr, field, value)
		}
		else{
			repositorio.objectNotFoundError(usr)
		}
	}
	
	def traerUsuarioPorNickname(Usuario usr, String value) throws Exception{
		return this.traerUsuarioDelRepositorio(usr, 'nickname', value)
	}
	
	def changePassword(Usuario usr, String newpassword) throws Exception{
		
		val usuarioACambiarPassword = this.traerUsuarioPorNickname(usr, usr.nickname)
		if(usuarioACambiarPassword.nickname.equals(newpassword))
		{
			new ChangingPasswordException('newpassword is the same that previous password')
		}
		else
		{
			usuarioACambiarPassword.password = newpassword
			repositorio.actualizar(usuarioACambiarPassword, 'password', newpassword)	
		}
	}
}
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
		if(repositorio.contiene(usr, usr.nickname)){
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
	
	//hacerlo mejor
	def crearMailParaUsuario(Usuario usuario, String codigo) {
		val mail = new Mail()
		mail.from = 'servicioDeRegistroDeMails'
		mail.to = usuario.email
		mail.body = codigo
		mail.subject = 'Codigo a validar'
		return mail
	}
	
	//esto no deberia estar
	def agregarUsuario(Usuario usuario) {
		usuarios.add(usuario)
	}
	//no se que hace aun
	
	def validar(Usuario usr, String codigo){
		if(repositorio.contiene(usr, usr.nickname)){
			val usrAValidar = repositorio.traer(usr)
			if(usrAValidar.codigo.equals(codigo)){
				usrAValidar.codigo = 'usado'
				repositorio.actualizar(usrAValidar)
			}
			else{
				new MyValidateException('codigo de validacion usado')
			}
		}
		else{
			repositorio.objectNotFoundError(usr)
		}
		
	}
	
	def login(String nickname, String password) throws Exception{
		
		val usrToLogin = new Usuario()
		usrToLogin.nickname = nickname
		
		if(repositorio.contiene(usrToLogin, nickname)){
			val usuarioFromRepo = repositorio.traer(usrToLogin)
			
			if(usuarioFromRepo.password.equals(password)){
				//new MyLoginException(usrToLogin.nickname + 'logged in')
				return usuarioFromRepo
			}
			else
			{
				new MyLoginException("password doesn't match")
			}
		}
		else{
			repositorio.objectNotFoundError(usrToLogin)
		}
	}
	
	def changePassword(Usuario usr, String newpassword){
		if(repositorio.contiene(usr, usr.nickname)){
			if(repositorio.traer(usr).nickname.equals(newpassword)){
				new ChangingPasswordException('newpassword is the same that previous password')
			}
			else
			{
			usr.password = newpassword
			repositorio.actualizar(usr)	
			}
		}
		else
		{
			repositorio.objectNotFoundError(usr)
		}
	}
}
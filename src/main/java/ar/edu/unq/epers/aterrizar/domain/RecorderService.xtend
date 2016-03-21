package ar.edu.unq.epers.aterrizar.domain

import ar.edu.unq.epers.aterrizar.domain.exceptions.MyLoginException
import ar.edu.unq.epers.aterrizar.domain.exceptions.RegistrationException
import ar.edu.unq.epers.aterrizar.persistence.Repositorio
import ar.edu.unq.epers.aterrizar.persistence.RepositorioUsuario
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

class RecorderService {
	
	@Accessors
	Repositorio<Usuario> repositorio
	@Accessors
	List<Usuario> usuarios
	@Accessors
	CreadorDeCodigos creadorDeCodigos
	@Accessors
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
		if(repositorio.contiene(usr)){
			new RegistrationException 'Nickname is being used'
		}
		else{
			this.nuevoUsuarioEnElSistema(usr)
		}
	}
	
	def nuevoUsuarioEnElSistema(Usuario usuario) {
		repositorio.persistir(usuario)
	}
	
	def agregarUsuario(Usuario usuario) {
		usuarios.add(usuario)
	}
	//no se que hace aun
	def validar(Usuario usr){
		
	}
	
	def login(String nickname, String password){
		val usrToLogin = new Usuario()
		usrToLogin.nickname = nickname
		if(repositorio.contiene(usrToLogin, nickname)){
			val usuarioFromRepo = repositorio.traer(usrToLogin)
			
			if(usuarioFromRepo.password.equals(password)){
				new MyLoginException(usrToLogin.nickname + 'logged in')
			}
			else{
				new MyLoginException("password doesn't match")
			}
		}
		else{
			new MyLoginException(nickname + "doesn't exist")
		}
	}
	
	def cambiarContrasenha(Usuario usr, String s){
		
		if()
		usr.cambiarContrasenha()
	}
}
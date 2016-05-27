package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.persistence.hibernate.SessionManager
import ar.edu.unq.epers.aterrizar.persistence.hibernate.RepositorioUsuarioHibernate
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ServicioRegistroUsuarioConHibernate extends ServicioDeRegistroDeUsuarios{
	
	RepositorioUsuarioHibernate repoHibernate
	ServicioDeAmigos servicioDeAmigos
	ServicioDePerfiles servicioDePerfiles
	
	new() {
		servicioDeAmigos = new ServicioDeAmigos(this)
		servicioDePerfiles = new ServicioDePerfiles(this)		
		repoHibernate = new RepositorioUsuarioHibernate
	}

	override registrarUsuario(Usuario usr) throws Exception{

		this.nuevoUsuarioEnElSistema(usr)
	}

	override validar(Usuario usr, String codigo) throws Exception{

		val usuarioAValidar = getUsuario(usr.nickname)
		usuarioAValidar.isValidadoCodigo()
		usuarioAValidar.validarCodigo(codigo)
		usuarioAValidar.usarCodigo()
		update(usuarioAValidar)
	}

	override login(String nickname, String password) throws Exception{
		val usuarioFromRepo = getUsuario(nickname)
		usuarioFromRepo.validarCodigo(this.codigoUsado())
		usuarioFromRepo.validarPassword(password)
		usuarioFromRepo
	}

	override changePassword(Usuario usr, String newpassword) throws Exception{

		val usuarioACambiarPassword = getUsuario(usr.nickname)
		usuarioACambiarPassword.validarCambioPassword(newpassword)
		usuarioACambiarPassword.password = newpassword

		update(usuarioACambiarPassword)
	}

	////////////////////////////////////////////
	override traerUsuarioDelRepositorio(String field, String value) throws Exception{
		val usuarioATraer = getUsuario(value)
		if(usuarioATraer == null){
			repoHibernate.objectDoesnotExist
		}
		usuarioATraer
	}
	
	override contieneUsuarioPorNickname(String nickname) {
		contain(nickname)
	}

	override traerUsuarioPorNickname(String nickname) throws Exception{
		getUsuario(nickname)
	}

	override nuevoUsuarioEnElSistema(Usuario usuario) {
		persist(usuario)
		servicioDeAmigos.crearUsuarioDeAmigos(usuario)
		servicioDePerfiles.crearPerfil(usuario)
		this.avisarNuevoUsuarioRegistrado(usuario)
	}
	//no les envio mas mails a estos usuarios
	override avisarNuevoUsuarioRegistrado(Usuario u){
		
	}

	override actualizarUsuarioPorNickname(Usuario usuario) {
		update(usuario)
	}

	override eliminarUsuario(Usuario u) {

		delete(u)
		servicioDeAmigos.eliminarUsuarioDeAmigos(u)
		servicioDePerfiles.eliminarPerfil(u)
	}

	def contain(String nick) {
		SessionManager.runInSession(
			[
				repoHibernate.contiene("nickname", nick)
			]
		)
	}

	def update(Usuario u) {
		SessionManager.runInSession(
			[
				repoHibernate.actualizar(u)
				null
			]
		)
	}

	def delete(Usuario u) {
		SessionManager.runInSession(
			[
				repoHibernate.borrar(u)
				null
			]
		)
	}

	def getUsuario(String nick) {
		SessionManager.runInSession(
			[
				repoHibernate.traer("nickname", nick)
			]
		)
	}
	def persist(Usuario u){
		SessionManager.runInSession(
			[
				repoHibernate.persistir(u)
				null
			]
		)		
	}


	
}
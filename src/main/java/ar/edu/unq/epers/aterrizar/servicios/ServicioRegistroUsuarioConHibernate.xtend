package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.persistence.hibernate.SessionManager
import ar.edu.unq.epers.aterrizar.persistence.hibernate.RepositorioUsuarioHibernate
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ServicioRegistroUsuarioConHibernate extends ServicioDeRegistroDeUsuarios {

	RepositorioUsuarioHibernate repoHibernate
	ServicioDeAmigos servicioDeAmigos
	ServicioDePerfiles servicioDePerfiles

	new() {
		this.servicioDeAmigos = new ServicioDeAmigos(this)
		this.servicioDePerfiles = new ServicioDePerfiles(this)
		this.repoHibernate = new RepositorioUsuarioHibernate
	}
	
	def sinCachePerfiles(){
		servicioDePerfiles = new ServicioDePerfiles(this)
	}
	def conCachePerfiles(){
		servicioDePerfiles = new ServicioDePerfilesConCache(this)
	}
	
	override registrarUsuario(Usuario usuario) throws Exception{

		persist(usuario)
		this.servicioDeAmigos.crearUsuarioDeAmigos(usuario)
		this.servicioDePerfiles.crearPerfil(usuario)
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

		//		usuarioFromRepo.validarCodigo(this.codigoUsado())
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
		if(usuarioATraer == null) {
			this.repoHibernate.objectDoesnotExist
		}
		usuarioATraer
	}

	override nuevoUsuarioEnElSistema(Usuario usuario) {
		persist(usuario)
		this.servicioDeAmigos.crearUsuarioDeAmigos(usuario)
		this.servicioDePerfiles.crearPerfil(usuario)
	}

	override actualizarUsuarioPorNickname(Usuario usuario) {
		update(usuario)
	}

	override contieneUsuarioPorNickname(String nickname) {
		contain(nickname)
	}

	override traerUsuarioPorNickname(String nickname) throws Exception{
		getUsuario(nickname)
	}

	override eliminarUsuario(Usuario u) {

		this.borrarDeAmigos(u)
		this.borrarDePerfiles(u)
		delete(u)
	}
	
	
	
	def void borrarDePerfiles(Usuario usuario) {
		servicioDePerfiles.eliminarPerfil(usuario)
	}

	def void borrarDeAmigos(Usuario usuario) {
		servicioDeAmigos.eliminarUsuarioDeAmigos(usuario)
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

	def persist(Usuario u) {
		SessionManager.runInSession(
			[
				repoHibernate.persistir(u)
				null
			]
		)
	}

	def deleteAll() {
		servicioDePerfiles.eliminarTodosLosPerfiles
		SessionManager.runInSession(
			[
				repoHibernate.deleteAll()
				null
			]
		)
	}

}

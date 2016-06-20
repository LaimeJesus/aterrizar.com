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
		setServicioDeAmigos(new ServicioDeAmigos(this))
		setServicioDePerfiles(new ServicioDePerfiles(this))
		setRepoHibernate(new RepositorioUsuarioHibernate)
	}
	
	def sinCachePerfiles(){
		setServicioDePerfiles(new ServicioDePerfiles(this))
	}
	def conCachePerfiles(){
		setServicioDePerfiles(new ServicioDePerfilesConCache(this))
	}
	
	override registrarUsuario(Usuario usuario) throws Exception{

		persist(usuario)
		getServicioDeAmigos.crearUsuarioDeAmigos(usuario)
		getServicioDePerfiles.crearPerfil(usuario)
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
			getRepoHibernate.objectDoesnotExist
		}
		usuarioATraer
	}

	override nuevoUsuarioEnElSistema(Usuario usuario) {
		persist(usuario)
		getServicioDeAmigos.crearUsuarioDeAmigos(usuario)
		getServicioDePerfiles.crearPerfil(usuario)
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
		getServicioDePerfiles.eliminarPerfil(usuario)
	}

	def void borrarDeAmigos(Usuario usuario) {
		getServicioDeAmigos.eliminarUsuarioDeAmigos(usuario)
	}
	
	def contain(String nick) {
		SessionManager.runInSession(
			[
				getRepoHibernate.contiene("nickname", nick)
			]
		)
	}

	def update(Usuario u) {
		SessionManager.runInSession(
			[
				getRepoHibernate.actualizar(u)
				null
			]
		)
	}

	def delete(Usuario u) {
		SessionManager.runInSession(
			[
				getRepoHibernate.borrar(u)
				null
			]
		)
	}

	def getUsuario(String nick) {
		SessionManager.runInSession(
			[
				getRepoHibernate.traer("nickname", nick)
			]
		)
	}

	def persist(Usuario u) {
		SessionManager.runInSession(
			[
				getRepoHibernate.persistir(u)
				null
			]
		)
	}

	def deleteAll() {
		getServicioDePerfiles.eliminarTodosLosPerfiles
		SessionManager.runInSession(
			[
				getRepoHibernate.deleteAll()
				null
			]
		)
	}

}

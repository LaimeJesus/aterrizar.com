package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.exceptions.RegistrationException
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.persistence.jdbc.RepositorioUsuario
import ar.edu.unq.epers.aterrizar.domain.mensajes.CreadorDeCodigos
import ar.edu.unq.epers.aterrizar.domain.mensajes.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.domain.mensajes.CreadorDeMails

@Accessors
class ServicioDeRegistroDeUsuarios {

	RepositorioUsuario repositorio
	CreadorDeCodigos creadorDeCodigos
	EnviadorDeMails enviadorDeMails
	CreadorDeMails creadorDeMails
	ServicioDeAmigos servicioDeAmigos
	ServicioDePerfiles servicioDePerfiles

	new() {
		setRepositorio(new RepositorioUsuario())
		setServicioDeAmigos(new ServicioDeAmigos(this))
		setServicioDePerfiles(new ServicioDePerfiles(this))
	}

	/*
	 * @throws exception if @param usr is already registered
	 */
	def registrarUsuario(Usuario usr) throws Exception{
		if(this.contieneUsuarioPorNickname(usr.nickname)) {
			throw new RegistrationException('Nickname is being used')
		} else {
			this.nuevoUsuarioEnElSistema(usr)
		}
	}

	/* validate the usr's code
	 * 
	 * @throws exception if @param usr is not registered
	 * @throws exception if usr's code is already used
	 * @throws exception if usr's code is different that @param codigo
	 * 
	 */
	def validar(Usuario usr, String codigo) throws Exception{

		val usuarioAValidar = this.traerUsuarioPorNickname(usr.nickname)
		usuarioAValidar.isValidadoCodigo()
		usuarioAValidar.validarCodigo(codigo)
		usuarioAValidar.usarCodigo()
		this.actualizarUsuarioPorNickname(usuarioAValidar)

	}

	/*
	 * @throws exception if @param usr is not registered
	 * @throws exception if the usr trying to log is not validated 
	 * @throws exception if the usr trying to log is using the wrong password
	 * @return usuario with nickname @param nickname
	 */
	def login(String nickname, String password) throws Exception{
		val usuarioFromRepo = this.traerUsuarioPorNickname(nickname)
		usuarioFromRepo.validarCodigo(this.codigoUsado())
		usuarioFromRepo.validarPassword(password)
		return usuarioFromRepo
	}
	/*
	 * @throws exception if @param usr is not registered
	 * @throws exception if the usr trying to log is not validated 
	 */
	def changePassword(Usuario usr, String newpassword) throws Exception{

		val usuarioACambiarPassword = this.traerUsuarioPorNickname(usr.nickname)
		usuarioACambiarPassword.validarCambioPassword(newpassword)
		usuarioACambiarPassword.password = newpassword
		getRepositorio.actualizar(usuarioACambiarPassword, 'nickname', usuarioACambiarPassword.nickname)
	}

	////////////////////////////////////////////
	def codigoUsado() {
		'usado'
	}

	def traerUsuarioDelRepositorio(String field, String value) throws Exception{
		if(getRepositorio.contiene(field, value)) {
			return getRepositorio.traer(field, value)
		} else {
			getRepositorio.objectNotFoundError()
		}
	}

	def contieneUsuarioPorNickname(String nickname) {
		return getRepositorio.contiene('nickname', nickname)
	}

	def traerUsuarioPorNickname(String nickname) throws Exception{
		return this.traerUsuarioDelRepositorio('nickname', nickname)
	}

	def nuevoUsuarioEnElSistema(Usuario usuario) {
		getRepositorio.persistir(usuario)

		getServicioDeAmigos.crearUsuarioDeAmigos(usuario)
		getServicioDePerfiles.crearPerfil(usuario)
		this.avisarNuevoUsuarioRegistrado(usuario)
	}

	def avisarNuevoUsuarioRegistrado(Usuario usuario) {

		val codigo = getCreadorDeCodigos.crearCodigo()
		val mailAEnviar = getCreadorDeMails.crearMailParaUsuario('registrador', usuario, codigo)
		getEnviadorDeMails.enviarMail(mailAEnviar)
	}

	def actualizarUsuarioPorNickname(Usuario usuario) {
		getRepositorio.actualizar(usuario, 'nickname', usuario.nickname)
	}

	def void eliminarUsuario(Usuario u) {
		getRepositorio.borrar("nickname", u.nickname)
		getServicioDePerfiles.eliminarPerfil(u)
		getServicioDeAmigos.eliminarUsuarioDeAmigos(u)
//		getServicioDeAmigos.eliminarMailsDeUsuario(u)
	}

	def isRegistrado(Usuario usuario) {
		if(!contieneUsuarioPorNickname(usuario.nickname)) {
			getRepositorio.objectNotFoundError()
		}
	}

}

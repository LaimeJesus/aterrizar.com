package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.perfiles.Comment
import ar.edu.unq.epers.aterrizar.domain.perfiles.DestinoPost
import ar.edu.unq.epers.aterrizar.exceptions.NoPuedeAgregarPostException
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.mongodb.Home
import ar.edu.unq.epers.aterrizar.persistence.mongodb.SistemDB
import org.mongojack.DBQuery
import ar.edu.unq.epers.aterrizar.domain.perfiles.visibility.Visibility
import ar.edu.unq.epers.aterrizar.domain.perfiles.Perfil

@Accessors
class ServicioDePerfiles {

	Home<Perfil> repositorioDePerfiles = SistemDB.instance().collection(Perfil)
	ServicioDeRegistroDeUsuarios servicioDeUsuarios
	ServicioDeBusquedaDeVuelos servicioDeBusqueda
	ServicioDeAmigos servicioDeAmigos

	new() {
	}

	new(ServicioDeRegistroDeUsuarios s) {
		setServicioDeUsuarios(s)
		setServicioDeBusqueda(new ServicioDeBusquedaDeVuelos())
	}

	new(ServicioDeRegistroDeUsuarios s, ServicioDeBusquedaDeVuelos serviciobusqueda, ServicioDeAmigos svA) {
		setServicioDeUsuarios(s)
		setServicioDeBusqueda(serviciobusqueda)
		setServicioDeAmigos(svA)
	}

	////////////////////////////////////////////////////////////////
	//Como usuario quiero agregar los destinos a los que fui
	////////////////////////////////////////////////////////////////
	def agregarPost(Usuario u, DestinoPost p) throws NoPuedeAgregarPostException{
		validarUsuario(u)
		validarViaje(u, p)

		val perfil = getPerfil(u)
		perfil.addPost(p)
		updatePerfil(perfil)

	}

	def validarViaje(Usuario u, DestinoPost p) {
		if(!getServicioDeBusqueda().viajeA(u, p.destino)) {
			throw new NoPuedeAgregarPostException("Nunca me visitaste")
		}

	}

	////////////////////////////////////////////////////////////////
	//Como usuario quiero a cada destino poder hacerle comentarios,
	//establecer “Me Gusta” o “No me gusta”
	////////////////////////////////////////////////////////////////
	def comentarPost(Usuario u, DestinoPost p, Comment c) {
		validarUsuario(u)
		val perfil = getPerfil(u)
		perfil.commentToPost(p, c)
		updatePerfil(perfil)
	}

	def meGusta(Usuario usuarioALikear, Usuario usuarioLikeando, DestinoPost p) {
		validarUsuarios(usuarioALikear, usuarioLikeando)

		val perfilLikeado = getPerfil(usuarioALikear)
		val perfilLikeando = getPerfil(usuarioLikeando)

		perfilLikeado.agregarMeGusta(perfilLikeando, p)
		updatePerfil(perfilLikeado)
	}

	def noMeGusta(Usuario aLikear, Usuario likeando, DestinoPost p) {
		validarUsuarios(aLikear, likeando)

		val perfilALikear = getPerfil(aLikear)
		val perfilLikeando = getPerfil(likeando)

		perfilALikear.agregarNoMeGusta(perfilLikeando, p)
		updatePerfil(perfilALikear)
	}

	def meGusta(Usuario aLikear, Usuario likeando, DestinoPost p, Comment c) {
		validarUsuarios(aLikear, likeando)

		val perfilALikear = getPerfil(aLikear)
		val perfilLikeando = getPerfil(likeando)

		perfilALikear.agregarMeGusta(perfilLikeando, p, c)
		updatePerfil(perfilALikear)
	}

	def noMeGusta(Usuario aLikear, Usuario likeando, DestinoPost p, Comment c) {

		validarUsuarios(aLikear, likeando)

		val perfilALikear = getPerfil(aLikear)
		val perfilLikeando = getPerfil(likeando)

		perfilALikear.agregarNoMeGusta(perfilLikeando, p, c)
		updatePerfil(perfilALikear)
	}

	def validarUsuario(Usuario usuario) {
		getServicioDeUsuarios().isRegistrado(usuario)
	}

	def validarUsuarios(Usuario usuario, Usuario usuario2) {
		getServicioDeUsuarios().isRegistrado(usuario)
		getServicioDeUsuarios().isRegistrado(usuario2)

	}

	def quitarMeGusta(Usuario u, Usuario q, DestinoPost p){
		validarUsuarios(u, q)
		
		val perfilAQuitar = getPerfil(u)
		val perfilQuitando = getPerfil(q)
		
		perfilAQuitar.quitarMeGusta(perfilQuitando, p)
		updatePerfil(perfilAQuitar)
	}
	def quitarNoMeGusta(Usuario u, Usuario q, DestinoPost p){
		validarUsuarios(u, q)
		
		val perfilAQuitar = getPerfil(u)
		val perfilQuitando = getPerfil(q)
		
		perfilAQuitar.quitarNoMeGusta(perfilQuitando, p)
		updatePerfil(perfilAQuitar)
	}

	def quitarMeGusta(Usuario u, Usuario q, DestinoPost p, Comment c){
		validarUsuarios(u, q)
		
		val perfilAQuitar = getPerfil(u)
		val perfilQuitando = getPerfil(q)
		
		perfilAQuitar.quitarMeGusta(perfilQuitando, p, c)
		updatePerfil(perfilAQuitar)
	}
	def quitarNoMeGusta(Usuario u, Usuario q, DestinoPost p, Comment c){
		validarUsuarios(u, q)
		
		val perfilAQuitar = getPerfil(u)
		val perfilQuitando = getPerfil(q)
		
		perfilAQuitar.quitarNoMeGusta(perfilQuitando, p, c)
		updatePerfil(perfilAQuitar)
	}

	////////////////////////////////////////////////////////////////
	//Como usuario quiero a cada destino y comentario establecerle un nivel de visibilidad,
	// privado, público y solo amigos.
	////////////////////////////////////////////////////////////////
	def cambiarAPublico(Usuario u, DestinoPost p) {
		validarUsuario(u)

		val perfil = getPerfil(u)
		perfil.toPublic(p)
		updatePerfil(perfil)
	}

	def cambiarAPublico(Usuario u, DestinoPost p, Comment c) {
		validarUsuario(u)
		val perfil = getPerfil(u)
		perfil.toPublic(p, c)
		updatePerfil(perfil)
	}

	def cambiarAPrivado(Usuario u, DestinoPost p) {
		validarUsuario(u)
		val perfil = getPerfil(u)
		perfil.toPrivate(p)
		updatePerfil(perfil)

	}

	def cambiarAPrivado(Usuario u, DestinoPost p, Comment c) {
		validarUsuario(u)
		val perfil = getPerfil(u)
		perfil.toPrivate(p, c)
		updatePerfil(perfil)
	}

	def cambiarASoloAmigos(Usuario u, DestinoPost p) {
		validarUsuario(u)
		val perfil = getPerfil(u)
		perfil.toOnlyFriends(p)
		updatePerfil(perfil)

	}

	def cambiarASoloAmigos(Usuario u, DestinoPost p, Comment c) {
		validarUsuario(u)
		val perfil = getPerfil(u)
		perfil.toOnlyFriends(p, c)
		updatePerfil(perfil)
	}

	////////////////////////////////////////////////////////////////
	//no pude hacer el filtrado de comentarios basicamente porque no me deja hacer un project
	//dentro de otro o al menos eso entendi
	//Como usuario quiero poder ver el perfil público de otro usuario, viendo lo que me 
	//corresponde según si soy amigo o no.
	////////////////////////////////////////////////////////////////
	def Perfil verPerfil(Usuario aVer, Usuario viendo) {
		validarUsuarios(aVer, viendo)

		val amigos = getServicioDeAmigos().sonAmigos(aVer, viendo)
		val esElMismo = aVer.nickname.equals(viendo.nickname)

		var visibilities = getVisibilities(amigos, esElMismo)

		var perfil = getRepositorioDePerfiles().getContents(aVer.nickname, visibilities)
		perfil
	}

	def getVisibilities(Boolean amigos, Boolean esElMismo) {
		if(esElMismo) {
			return #[Visibility.PUBLIC, Visibility.PRIVATE, Visibility.ONLYFRIENDS]
		}
		if(amigos) {
			return #[Visibility.PUBLIC, Visibility.ONLYFRIENDS]
		}
		return #[Visibility.PUBLIC]
	}

	////////////////////////////////////////////////////////////////////////////////
	//utilities
	////////////////////////////////////////////////////////////////////////////////
	def Perfil getPerfil(Usuario usuario) throws Exception{

		//		getRepositorioDePerfiles().find("nickname", usuario.nickname)
		getRepositorioDePerfiles().find(DBQuery.is("nickname", usuario.nickname)).get(0)
	}

	def void updatePerfil(Perfil perfil) {

		getRepositorioDePerfiles().update(perfil.idPerfil, perfil)
	}

	def void insertPerfil(Perfil perfil) {
		getRepositorioDePerfiles().insert(perfil)

	}

	def crearPerfil(Usuario usuario) {
		var p = new Perfil(usuario.nickname)
		getRepositorioDePerfiles().insert(p)
	}

	def void eliminarPerfil(Usuario usuario) {
		getRepositorioDePerfiles().delete("nickname", usuario.nickname)
	}

	def void eliminarTodosLosPerfiles() {
		getRepositorioDePerfiles().deleteAll()
	}

}

package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.redsocial.Comment
import ar.edu.unq.epers.aterrizar.domain.redsocial.DestinoPost
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil
import ar.edu.unq.epers.aterrizar.exceptions.NoPuedeAgregarPostException
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.mongodb.Home
import ar.edu.unq.epers.aterrizar.persistence.mongodb.SistemDB
import org.mongojack.DBQuery

@Accessors
class ServicioDePerfiles {

	Home<Perfil> repositorioDePerfiles

	ServicioDeRegistroDeUsuarios servicioDeUsuarios

	ServicioDeBusquedaDeVuelos servicioDeBusqueda

	//    Como usuario quiero poder agregar destinos a los que fui.
	new(ServicioDeRegistroDeUsuarios s) {
		servicioDeUsuarios = s
		repositorioDePerfiles = SistemDB.instance().collection(Perfil)
		servicioDeBusqueda = new ServicioDeBusquedaDeVuelos
	}

	new(ServicioDeRegistroDeUsuarios s, ServicioDeBusquedaDeVuelos sb) {
		servicioDeUsuarios = s
		repositorioDePerfiles = SistemDB.instance().collection(Perfil)
		servicioDeBusqueda = sb
	}

	// en realidad es agregarDestino
	def agregarPost(Usuario u, DestinoPost p) throws NoPuedeAgregarPostException{
		servicioDeUsuarios.isRegistrado(u)

		//		if(!servicioDeBusqueda.viajeA(u, p.destino)) {
		//			throw new NoPuedeAgregarPostException("Nunca me visitaste")
		//		}
		val perfil = getPerfil(u)
		perfil.addPost(p)
		updatePerfil(perfil)

	}

	//    Como usuario quiero a cada destino poder hacerle comentarios, establecer “Me Gusta” o “No me gusta”
	def comentarPost(Usuario u, DestinoPost p, Comment c) {
		servicioDeUsuarios.isRegistrado(u)
		val perfil = getPerfil(u)
		perfil.commentToPost(p, c)
		updatePerfil(perfil)
	}

	def meGusta(Usuario usuarioALikear, Usuario usuarioLikeando, DestinoPost p) {
		servicioDeUsuarios.isRegistrado(usuarioALikear)
		servicioDeUsuarios.isRegistrado(usuarioLikeando)
		val perfilLikeado = getPerfil(usuarioALikear)
		val perfilLikeando = getPerfil(usuarioLikeando)
		perfilLikeado.agregarMeGusta(perfilLikeando, p)
		updatePerfil(perfilLikeado)
	}

	def noMeGusta(Usuario aLikear, Usuario likeando, DestinoPost p) {
		servicioDeUsuarios.isRegistrado(aLikear)
		servicioDeUsuarios.isRegistrado(likeando)
		val perfilALikear = getPerfil(aLikear)
		val perfilLikeando = getPerfil(likeando)
		perfilALikear.agregarNoMeGusta(perfilLikeando, p)
		updatePerfil(perfilALikear)
	}

	def meGusta(Usuario aLikear, Usuario likeando, DestinoPost p, Comment c) {
		servicioDeUsuarios.isRegistrado(aLikear)
		servicioDeUsuarios.isRegistrado(likeando)
		val perfilALikear = getPerfil(aLikear)
		val perfilLikeando = getPerfil(likeando)
		perfilALikear.agregarMeGusta(perfilLikeando, p, c)
		updatePerfil(perfilALikear)
	}

	def noMeGusta(Usuario aLikear, Usuario likeando, DestinoPost p, Comment c) {
		servicioDeUsuarios.isRegistrado(aLikear)
		servicioDeUsuarios.isRegistrado(likeando)
		val perfilALikear = getPerfil(aLikear)
		val perfilLikeando = getPerfil(likeando)
		perfilALikear.agregarNoMeGusta(perfilLikeando, p, c)
		updatePerfil(perfilALikear)
	}

	//    Como usuario quiero a cada destino y comentario establecerle un nivel de visibilidad, privado, público y solo amigos.
	def cambiarAPublico(Usuario u, DestinoPost p) {
		servicioDeUsuarios.isRegistrado(u)
		val perfil = getPerfil(u)
		
		perfil.configVisibilityIntoPublic(p)

		updatePerfil(perfil)
	}

	def cambiarAPublico(Usuario u, DestinoPost p, Comment c) {
		servicioDeUsuarios.isRegistrado(u)
		val perfil = getPerfil(u)
		perfil.configVisibilityIntoPublic(p, c)
		updatePerfil(perfil)
	}

	def cambiarAPrivado(Usuario u, DestinoPost p) {
		servicioDeUsuarios.isRegistrado(u)
		val perfil = getPerfil(u)
		perfil.configVisibilityIntoPrivate(p)
		updatePerfil(perfil)

	}

	def cambiarAPrivado(Usuario u, DestinoPost p, Comment c) {
		servicioDeUsuarios.isRegistrado(u)
		val perfil = getPerfil(u)
		perfil.configVisibilityIntoPrivate(p, c)
		updatePerfil(perfil)
	}

	def cambiarASoloAmigos(Usuario u, DestinoPost p) {
		servicioDeUsuarios.isRegistrado(u)
		val perfil = getPerfil(u)
		perfil.configVisibilityIntoJustFriends(p)
		updatePerfil(perfil)

	}

	def cambiarASoloAmigos(Usuario u, DestinoPost p, Comment c) {
		servicioDeUsuarios.isRegistrado(u)
		val perfil = getPerfil(u)
		perfil.configVisibilityIntoJustFriends(p, c)
		updatePerfil(perfil)
	}

	//    Como usuario quiero poder ver el perfil público de otro usuario, viendo lo que me corresponde según si soy amigo o no.
	def Perfil verPerfil(Usuario aVer, Usuario viendo) {
		servicioDeUsuarios.isRegistrado(aVer)
		servicioDeUsuarios.isRegistrado(viendo)
		val perfilAVer = getPerfil(aVer)
		val perfilViendo = getPerfil(viendo)
		perfilAVer.getContents(perfilViendo)
	}

	////////////////////////////////////////////////////////////////////////////////
	//utilities
	////////////////////////////////////////////////////////////////////////////////
	def getPerfil(Usuario usuario) throws Exception{
		repositorioDePerfiles.find(DBQuery.is("nickname", usuario.nickname)).get(0)
	}

	def void updatePerfil(Perfil perfil) {
		repositorioDePerfiles.actualizar(perfil.idPerfil, perfil)

	}

	def insertPerfil(Perfil perfil) {
		repositorioDePerfiles.insert(perfil)
	}

	def crearPerfil(Usuario usuario) {
		var p = new Perfil(usuario.nickname)
		repositorioDePerfiles.insert(p)
	}

	def void eliminarPerfil(Usuario usuario) {
		repositorioDePerfiles.delete("username", usuario.nickname)
	}

	def void eliminarTodosLosPerfiles() {
		repositorioDePerfiles.deleteAll()
	}

}

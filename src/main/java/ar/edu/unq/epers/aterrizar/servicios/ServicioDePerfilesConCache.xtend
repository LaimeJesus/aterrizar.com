package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.mongodb.Home
import org.mongojack.DBQuery
import ar.edu.unq.epers.aterrizar.domain.perfiles.Perfil
import ar.edu.unq.epers.aterrizar.persistence.mongodb.SistemDB

@Accessors
class ServicioDePerfilesConCache extends ServicioDePerfiles {

	Home<Perfil> repositorioDePerfiles = SistemDB.instance().collection(Perfil)
	ServicioDeRegistroDeUsuarios servicioDeUsuarios
	ServicioDeBusquedaDeVuelos servicioDeBusqueda = new ServicioDeBusquedaDeVuelos()
	ServicioDeAmigos servicioDeAmigos
	ServicioDeCacheDePerfiles cacheDePerfiles = new ServicioDeCacheDePerfiles()

	//    Como usuario quiero poder agregar destinos a los que fui.
	new(ServicioRegistroUsuarioConHibernate hibernate, ServicioDeAmigos friendSrv) {
		setServicioDeUsuarios(hibernate)
		setServicioDeAmigos(friendSrv)
	}

	new(ServicioRegistroUsuarioConHibernate hibernate) {
		setServicioDeUsuarios(hibernate)
	}

	////////////////////////////////////////////////////////////////
	//no pude hacer el filtrado de comentarios basicamente porque no me deja hacer un project
	//dentro de otro o al menos eso no me dejaba
	//Como usuario quiero poder ver el perfil público de otro usuario, viendo lo que me 
	//corresponde según si soy amigo o no.
	////////////////////////////////////////////////////////////////
	override Perfil verPerfil(Usuario aVer, Usuario viendo) {
		getServicioDeUsuarios.isRegistrado(aVer)
		getServicioDeUsuarios.isRegistrado(viendo)

		val amigos = getServicioDeAmigos.sonAmigos(aVer, viendo)
		val esElMismo = aVer.nickname.equals(viendo.nickname)

		var isCached = getCacheDePerfiles.cached(aVer.nickname)
		if(isCached) {
			return getCacheDePerfiles.get(aVer.nickname, amigos, esElMismo)
		}
		var visibilities = getVisibilities(amigos, esElMismo)

		var perfil = getRepositorioDePerfiles.getContents(aVer.nickname, visibilities)
		var privateps = perfil.privatePosts
		var jsps = perfil.justFriendsPosts
		var pubps = perfil.publicPosts
		perfil.posts.addAll(pubps)
		perfil.posts.addAll(privateps)
		perfil.posts.addAll(jsps)
		
		getCacheDePerfiles.cache(perfil)

		perfil
	}

	////////////////////////////////////////////////////////////////////////////////
	//utilities
	////////////////////////////////////////////////////////////////////////////////
	override getPerfil(Usuario usuario) throws Exception{

//		if(cacheDePerfiles.cached(usuario.nickname)) {
//			return cacheDePerfiles.get(usuario.nickname)
//		} else {
			var p = getRepositorioDePerfiles.find(DBQuery.is("nickname", usuario.nickname)).get(0)
			getCacheDePerfiles.cache(p)
			return p
//		}
	}

	override void updatePerfil(Perfil perfil) {

		getRepositorioDePerfiles.update(perfil.idPerfil, perfil)

		//deberia actualizarlo de la bd? o solamente lo borro?
		//		cacheDePerfiles.delete(perfil.nickname)
		if(getCacheDePerfiles.cached(perfil.nickname)) {
			getCacheDePerfiles.update(perfil)
		}

	}

	override void eliminarPerfil(Usuario usuario) {
		getRepositorioDePerfiles.delete("nickname", usuario.nickname)

		//no hace falta el if
		if(getCacheDePerfiles.cached(usuario.nickname)) {
			getCacheDePerfiles.delete(usuario.nickname)
		}
	}
}

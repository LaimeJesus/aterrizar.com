package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistence.mongodb.Home
import org.mongojack.DBQuery
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil
import ar.edu.unq.epers.aterrizar.persistence.mongodb.SistemDB

@Accessors
class ServicioDePerfilesConCache extends ServicioDePerfiles {

	Home<Perfil> repositorioDePerfiles = SistemDB.instance().collection(Perfil)
	ServicioDeRegistroDeUsuarios servicioDeUsuarios
	ServicioDeBusquedaDeVuelos servicioDeBusqueda = new ServicioDeBusquedaDeVuelos()
	ServicioDeAmigos servicioDeAmigos
	ServicioDeCacheDePerfiles cacheDePerfiles = new ServicioDeCacheDePerfiles()

	//    Como usuario quiero poder agregar destinos a los que fui.
	new(ServicioRegistroUsuarioConHibernate hibernate) {
		servicioDeUsuarios = hibernate
	}

	new() {
	}

	////////////////////////////////////////////////////////////////
	//no pude hacer el filtrado de comentarios basicamente porque no me deja hacer un project
	//dentro de otro o al menos eso entendi
	//Como usuario quiero poder ver el perfil público de otro usuario, viendo lo que me 
	//corresponde según si soy amigo o no.
	////////////////////////////////////////////////////////////////
	override Perfil verPerfil(Usuario aVer, Usuario viendo) {
		servicioDeUsuarios.isRegistrado(aVer)
		servicioDeUsuarios.isRegistrado(viendo)

		val amigos = servicioDeAmigos.sonAmigos(aVer, viendo)
		val esElMismo = aVer.nickname.equals(viendo.nickname)

		var isCached = cacheDePerfiles.cached(aVer.nickname)
		print("VIENDO SI ESTA CACHEADO LPM: ")
		println(isCached)
		if(isCached) {
			println("ESTA CACHEADOOOOOOO")
			return cacheDePerfiles.get(aVer.nickname, amigos, esElMismo)
		}
		var visibilities = getVisibilities(amigos, esElMismo)

		var perfil = repositorioDePerfiles.getContents(aVer.nickname, visibilities)

		cacheDePerfiles.cache(perfil)

		perfil
	}

	////////////////////////////////////////////////////////////////////////////////
	//utilities
	////////////////////////////////////////////////////////////////////////////////
	override getPerfil(Usuario usuario) throws Exception{

		if(cacheDePerfiles.cached(usuario.nickname)) {
			return cacheDePerfiles.get(usuario.nickname)
		} else {
			var p = repositorioDePerfiles.find(DBQuery.is("nickname", usuario.nickname)).get(0)
			cacheDePerfiles.cache(p)
			return p
		}
	}

	override void updatePerfil(Perfil perfil) {

		repositorioDePerfiles.update(perfil.idPerfil, perfil)

		//deberia actualizarlo de la bd? o solamente lo borro?
		//		cacheDePerfiles.delete(perfil.nickname)
		if(cacheDePerfiles.cached(perfil.nickname)) {
			cacheDePerfiles.update(perfil)
		}

	}

	override void eliminarPerfil(Usuario usuario) {
		repositorioDePerfiles.delete("nickname", usuario.nickname)

		//no hace falta el if
		if(cacheDePerfiles.cached(usuario.nickname)) {
			cacheDePerfiles.delete(usuario.nickname)
		}
	}
}

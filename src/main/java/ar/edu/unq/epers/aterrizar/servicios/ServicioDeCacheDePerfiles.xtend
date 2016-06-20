package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.persistence.cassandra.RepositorioPerfiles
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.perfiles.Perfil

@Accessors
class ServicioDeCacheDePerfiles {

	RepositorioPerfiles repoCacheDePerfiles

	new(){
		setRepoCacheDePerfiles(new RepositorioPerfiles())
	}

	def cached(String nick) {
		getRepoCacheDePerfiles.contains(nick)
	}

	def Perfil get(String nick) {
		getRepoCacheDePerfiles.get(nick, true, true)
	}

	def Perfil get(String nick, boolean amigos, boolean privado) {
		getRepoCacheDePerfiles.get(nick, amigos, privado)
	}

	def void update(Perfil perfil) {
		getRepoCacheDePerfiles.update(perfil)
	}

	def void cache(Perfil perfil) {
		getRepoCacheDePerfiles.persist(perfil)
	}

	def void delete(String pk) {
		getRepoCacheDePerfiles.delete(pk)
	}
	
	def disconect() {
		getRepoCacheDePerfiles.actualSession.close
	}

}

package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.persistence.cassandra.RepositorioPerfiles
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil

@Accessors
class ServicioDeCacheDePerfiles {

	RepositorioPerfiles repoCacheDePerfiles

	new(){
		repoCacheDePerfiles = new RepositorioPerfiles()
	}

	def cached(String nick) {
		repoCacheDePerfiles.contains(nick)
	}

	def Perfil get(String nick) {
		repoCacheDePerfiles.get(nick, true, true)
	}

	def Perfil get(String nick, boolean amigos, boolean privado) {
		repoCacheDePerfiles.get(nick, amigos, privado)
	}

	def void update(Perfil perfil) {
		repoCacheDePerfiles.update(perfil)
	}

	def void cache(Perfil perfil) {
		repoCacheDePerfiles.persist(perfil)
	}

	def void delete(String pk) {
		repoCacheDePerfiles.delete(pk)
	}
	
	def disconect() {
		repoCacheDePerfiles.actualSession.close
	}

}

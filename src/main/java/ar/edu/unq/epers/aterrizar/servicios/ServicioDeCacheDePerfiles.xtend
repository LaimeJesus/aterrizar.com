package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.persistence.cassandra.RepositorioPerfiles
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil

@Accessors
class ServicioDeCacheDePerfiles {

	RepositorioPerfiles repoCacheDePerfiles

	def cached(String nick) {
		repoCacheDePerfiles.get("", nick) == null
	}

	def cached(String nick, boolean amigos, boolean privado) {
		false
	}

	def Perfil get(String nick) {
		repoCacheDePerfiles.get("nickname", nick)
	}

	def Perfil get(String nick, boolean amigos, boolean privado) {
		null
	}

	def isUpdated(Perfil p) {
		false
	}

	def void update(Perfil perfil) {
		repoCacheDePerfiles.update(perfil)
	}

	def void cache(Perfil perfil) {
		repoCacheDePerfiles.persist(perfil)
	}

	def void cache(Perfil p, boolean amigos, boolean privado) {
	}

	def void delete(String pk) {
		repoCacheDePerfiles.delete("", pk)
	}

}

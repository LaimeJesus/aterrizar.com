package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.persistence.cassandra.RepositorioPerfiles
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil

@Accessors
class ServicioDeCacheDePerfiles {

	RepositorioPerfiles repoCacheDePerfiles

	def cached(String nick) {
		false
	}

	def cached(String nick, boolean amigos, boolean privado) {
		false
	}

	def get(String nick) {
		repoCacheDePerfiles.get("nickname", nick)
	}

	def get(String nick, boolean amigos, boolean privado) {
		repoCacheDePerfiles.get("nickname", nick)
	}

	def isUpdated(Perfil p) {
		false
	}

	def void update(Perfil perfil) {
	}

	def void cache(Perfil perfil) {
	}

	def void cache(Perfil p, boolean amigos, boolean privado) {
	}

	def void delete(String string) {
	}

}

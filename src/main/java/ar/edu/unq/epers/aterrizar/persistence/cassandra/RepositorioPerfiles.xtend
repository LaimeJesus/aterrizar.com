package ar.edu.unq.epers.aterrizar.persistence.cassandra

import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.MappingManager
import com.datastax.driver.mapping.Mapper
import ar.edu.unq.epers.aterrizar.utils.ArmadorDeDeclaraciones
import com.datastax.driver.core.Session
import ar.edu.unq.epers.aterrizar.domain.perfiles.Perfil
import ar.edu.unq.epers.aterrizar.domain.perfiles.visibility.Visibility
import com.datastax.driver.extras.codecs.enums.EnumNameCodec
import ar.edu.unq.epers.aterrizar.persistence.cassandra.DTOs.PerfilDTO
import com.datastax.driver.core.CodecRegistry

@Accessors
class RepositorioPerfiles extends RepositorioCassandra<PerfilDTO> {

	CassandraConnector connector
	ArmadorDeDeclaraciones creator
	Mapper<PerfilDTO> mapper

	Session actualSession

	new() {
		setCreator(new ArmadorDeDeclaraciones)
		setConnector(new CassandraConnector())
		
		createSimpleKEYSPACE("aterrizar", "3")
		getConnector.setKeyspace("aterrizar")

		setActualSession(getConnector.session)
		var enumCodec = new EnumNameCodec<Visibility>(Visibility)

		//		connector.cluster.configuration.codecRegistry.register(enumCodec)
		CodecRegistry.DEFAULT_INSTANCE.register(enumCodec)

		createScheme()

		//		var mapMan = new MappingManager(getActualSession)
		setMapper(new MappingManager(getActualSession).mapper(PerfilDTO))
	}

	def createScheme() {

		val fytl = "(id text, nickname text);"
		var like = "CREATE TYPE IF NOT EXISTS aterrizar.like " + fytl
		getConnector.execute(like)

		val fytla = "(meGusta list<frozen <like>>, noMeGusta list<frozen<like>>);"
		var likeadmin = "CREATE TYPE IF NOT EXISTS aterrizar.likeAdmin " + fytla
		getConnector.execute(likeadmin)

		//, visibility Visibility 3
		var fytc = " (id text, likesAdmin frozen <likeAdmin>, visibility text, comment text);"
		var comment = "CREATE TYPE IF NOT EXISTS aterrizar.comment " + fytc
		getConnector.execute(comment)

		//, visibility Visibility 4
		var fytdp = " (id text, comments list<frozen <comment>>, likesAdmin frozen<likeAdmin>, visibility text, destino text);"
		var destinoPost = "CREATE TYPE IF NOT EXISTS aterrizar.destinoPost " + fytdp
		getConnector.execute(destinoPost)

		//,visibility Visibility 2
		var fieldsAndTypes = "(nickname text, visibility text, idPerfil text, posts list<frozen <destinoPost>>, PRIMARY KEY(nickname, visibility));"
		var perfil = "CREATE TABLE IF NOT EXISTS aterrizar.Perfil" + fieldsAndTypes
		getConnector.execute(perfil)
	}

	def void persist(Perfil p) {
		var dto = toDTO(p)

		//persisto la parte de perfil publico
		var publics = p.getPublicPosts()
		dto.visibility = Visibility.PUBLIC
		dto.posts = publics
		getMapper.save(dto)

		//persisto la parte de perfil privado
		var privates = p.getPrivatePosts()
		dto.visibility = Visibility.PRIVATE
		dto.posts = privates
		getMapper.save(dto)

		//persisto la parte de perfil solo amigos
		var jfs = p.getJustFriendsPosts()
		dto.visibility = Visibility.ONLYFRIENDS
		dto.posts = jfs
		getMapper.save(dto)
	}

	def void delete(String nick) {

		//borro los 3 perfiles
		getMapper.delete(nick, Visibility.PUBLIC)
		getMapper.delete(nick, Visibility.PRIVATE)
		getMapper.delete(nick, Visibility.ONLYFRIENDS)
	}

	def void update(Perfil p) {
		delete(p.nickname)
		persist(p)
	}

	def contains(String nick) {
		var pub = getMapper.get(nick, Visibility.PUBLIC)
		var priv = getMapper.get(nick, Visibility.PRIVATE)
		var jsf = getMapper.get(nick, Visibility.ONLYFRIENDS)
		var b = pub != null || priv != null || jsf != null
		b
	}

	def Perfil get(String nick, boolean isAmigo, boolean isPrivado) {

		//traigo el perfil publico
		val public = getMapper.get(nick, Visibility.PUBLIC)
		val r = public.posts
		if(isPrivado) {

			//traigo la parte de perfil privado
			val private = getMapper.get(nick, Visibility.PRIVATE)
			r.addAll(private.posts)
		}
		if(isAmigo) {

			//traigo la parte de perfil solo amigos
			val amigos = getMapper.get(nick, Visibility.ONLYFRIENDS)
			r.addAll(amigos.posts)
		}

		new Perfil() => [
			nickname = nick
			idPerfil = public.idPerfil
			posts = r
		]
	}

	def toPerfil(PerfilDTO dto) {
		new Perfil() => [
			nickname = dto.nickname
			idPerfil = dto.idPerfil
			posts = dto.posts
		]
	}

	def PerfilDTO toDTO(Perfil perfil) {
		new PerfilDTO() => [
			nickname = perfil.nickname
			idPerfil = perfil.idPerfil
			posts = perfil.posts
		]
	}

}

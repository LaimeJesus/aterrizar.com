package ar.edu.unq.epers.aterrizar.persistence.cassandra

import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.MappingManager
import com.datastax.driver.mapping.Mapper
import ar.edu.unq.epers.aterrizar.utils.ArmadorDeDeclaraciones
import com.datastax.driver.core.Session
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil
import ar.edu.unq.epers.aterrizar.domain.redsocial.visibility.Visibility
import com.datastax.driver.extras.codecs.enums.EnumNameCodec
import ar.edu.unq.epers.aterrizar.persistence.cassandra.DTOs.PerfilDTO
import com.datastax.driver.core.CodecRegistry

@Accessors
class RepositorioPerfiles extends RepositorioCassandra<PerfilDTO> {

	CassandraConnector connector
	ArmadorDeDeclaraciones creator
	Mapper<PerfilDTO> mapper

	Session actualSession

	val final pub = Visibility.PUBLIC
	val final priv = Visibility.PRIVATE
	val final jf = Visibility.JUSTFRIENDS
	
	new() {
		creator = new ArmadorDeDeclaraciones

		connector = new CassandraConnector()
		createSimpleKEYSPACE("aterrizar", "3")
		connector.keyspace = "aterrizar"

		actualSession = connector.session
		var enumCodec = new EnumNameCodec<Visibility>(Visibility)
//		connector.cluster.configuration.codecRegistry.register(enumCodec)
		CodecRegistry.DEFAULT_INSTANCE.register(enumCodec)

		createScheme()
		var mapManager = new MappingManager(actualSession)

		//		mapManager.udtCodec(Like)
		//		mapManager.udtCodec(LikeAdmin)
		//		mapManager.udtCodec(Comment)
		//		mapManager.udtCodec(DestinoPost)
		mapper = mapManager.mapper(PerfilDTO)
	}

	def createScheme() {

		val fytl = "(id text, nickname text);"
		var like = "CREATE TYPE IF NOT EXISTS aterrizar.like " + fytl
		connector.execute(like)

		val fytla = "(meGusta list<frozen <like>>, noMeGusta list<frozen<like>>);"
		var likeadmin = "CREATE TYPE IF NOT EXISTS aterrizar.likeAdmin " + fytla
		connector.execute(likeadmin)

		//, visibility Visibility 3
		var fytc = " (id text, likesAdmin frozen <likeAdmin>, visibility text, comment text);"
		var comment = "CREATE TYPE IF NOT EXISTS aterrizar.comment " + fytc
		connector.execute(comment)

		//, visibility Visibility 4
		var fytdp = " (id text, comments list<frozen <comment>>, likesAdmin frozen<likeAdmin>, visibility text, destino text);"
		var destinoPost = "CREATE TYPE IF NOT EXISTS aterrizar.destinoPost " + fytdp
		connector.execute(destinoPost)

		//,visibility Visibility 2
		var fieldsAndTypes = "(nickname text, visibility text, idPerfil text, posts list<frozen <destinoPost>>, PRIMARY KEY(nickname, visibility));"
		var perfil = "CREATE TABLE IF NOT EXISTS aterrizar.Perfil" + fieldsAndTypes
		connector.execute(perfil)
	}

	def void persist(Perfil p) {
		var dto = toDTO(p)
		var publics = p.getPublicPosts()
		dto.visibility = Visibility.PUBLIC
		dto.posts = publics
		mapper.save(dto)
		var privates = p.getPrivatePosts()
		dto.visibility = Visibility.PRIVATE
		dto.posts = privates
		mapper.save(dto)
		var jfs = p.getJustFriendsPosts()
		dto.visibility = Visibility.JUSTFRIENDS
		dto.posts = jfs
		mapper.save(dto)
	}

	def void delete(String nick) {
		mapper.delete(nick, Visibility.PUBLIC)
		mapper.delete(nick, Visibility.PRIVATE)
		mapper.delete(nick, Visibility.JUSTFRIENDS)
	}

	def void update(Perfil p) {
		delete(p.nickname)
		persist(p)
	}

	def PerfilDTO toDTO(Perfil perfil) {
		new PerfilDTO() => [
			nickname = perfil.nickname
			idPerfil = perfil.idPerfil
			posts = perfil.posts
		]
	}

	def Perfil get(String nick, boolean isAmigo, boolean isPrivado) {
		val public = mapper.get(nick, Visibility.PUBLIC)
		val r = public.posts
		if(isPrivado) {
			val private = mapper.get(nick, Visibility.PRIVATE)
			r.addAll(private.posts)
		}
		if(isAmigo) {
			val amigos = mapper.get(nick, Visibility.JUSTFRIENDS)
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

	def contains(String nick) {
		var pub = mapper.get(nick, Visibility.PUBLIC)
		var priv = mapper.get(nick, Visibility.PRIVATE)
		var jsf = mapper.get(nick, Visibility.JUSTFRIENDS)
		var b = pub != null || priv != null || jsf != null
		b
	}

}

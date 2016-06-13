package ar.edu.unq.epers.aterrizar.persistence.cassandra

import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.MappingManager
import com.datastax.driver.mapping.Mapper
import ar.edu.unq.epers.aterrizar.utils.ArmadorDeDeclaraciones
import com.datastax.driver.core.Session
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil
import ar.edu.unq.epers.aterrizar.domain.redsocial.visibility.Visibility
import com.datastax.driver.extras.codecs.enums.EnumNameCodec
import ar.edu.unq.epers.aterrizar.domain.redsocial.DestinoPost
import ar.edu.unq.epers.aterrizar.domain.redsocial.Comment
import ar.edu.unq.epers.aterrizar.domain.redsocial.LikeAdmin
import ar.edu.unq.epers.aterrizar.domain.redsocial.Like

@Accessors
class RepositorioPerfiles extends RepositorioCassandra<Perfil> {

	CassandraConnector connector
	ArmadorDeDeclaraciones creator
	Mapper<Perfil> mapper

	Session actualSession

	new() {
		creator = new ArmadorDeDeclaraciones

		connector = new CassandraConnector()
		createSimpleKEYSPACE("aterrizar", "1")
		connector.keyspace = "aterrizar"

		actualSession = connector.session
		var enumCodec = new EnumNameCodec<Visibility>(Visibility)
		var codecReg = connector.cluster.configuration.codecRegistry
		codecReg.register(enumCodec)
		createScheme()

//		new MappingManager(actualSession).udtCodec(Like)
//		new MappingManager(actualSession).udtCodec(LikeAdmin)
//		new MappingManager(actualSession).udtCodec(Comment)
//		new MappingManager(actualSession).udtCodec(DestinoPost)
		mapper = new MappingManager(actualSession).mapper(Perfil)

	}

	def createScheme() {

		val fytl = "(id text, nickname text);"
		var like = "CREATE TYPE IF NOT EXISTS aterrizar.like " + fytl
		connector.execute(like)

		val fytla = "(meGusta list<frozen <like>>, noMeGusta list<frozen<like>>);"
		var likeadmin = "CREATE TYPE IF NOT EXISTS aterrizar.likeAdmin " + fytla
		connector.execute(likeadmin)

		//, visibility Visibility
		var fytc = " (id text, likesAdmin frozen <likeAdmin>, comment text);"
		var comment = "CREATE TYPE IF NOT EXISTS aterrizar.comment " + fytc
		connector.execute(comment)

		//, visibility Visibility
		var fytdp = " (id text, comments list<frozen <comment>>, likesAdmin frozen<likeAdmin>, destino text);"
		var destinoPost = "CREATE TYPE IF NOT EXISTS aterrizar.destinoPost " + fytdp
		connector.execute(destinoPost)

		var fieldsAndTypes = "(nickname text, idPerfil text, posts list<frozen <destinoPost>>, PRIMARY KEY(nickname));"
		var perfil = "CREATE TABLE IF NOT EXISTS aterrizar.PerfilDTO " + fieldsAndTypes
		connector.execute(perfil)
	}

	override persist(Perfil p) {
		mapper.save(p)
	}

	override get(String field, String value) {
		mapper.get(value)
	}
}

package ar.edu.unq.epers.aterrizar.persistence.mongodb;

import java.util.List
import org.mongojack.DBQuery.Query
import org.mongojack.JacksonDBCollection
import org.mongojack.MapReduce
import org.mongojack.DBQuery
import com.mongodb.BasicDBObject
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.redsocial.visibility.Visibility
import com.mongodb.BasicDBList
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil

class Home<T> {
	private JacksonDBCollection<T, String> mongoCollection;

	new(JacksonDBCollection<T, String> collection) {
		this.mongoCollection = collection
	}

	def insert(T object) {
		return mongoCollection.insert(object);
	}

	def insert(List<T> object) {
		return mongoCollection.insert(object);
	}

	def find(Query object) {
		return mongoCollection.find(object);
	}

	def <E, S> mapReduce(String map, String reduce, Class<E> entrada, Class<S> salida) {
		return mongoCollection.mapReduce(mapReduceCommand(map, reduce, entrada, salida));
	}

	def <E, S> mapReduce(String map, String reduce, String finalize, Class<E> entrada, Class<S> salida) {
		return mongoCollection.mapReduce(mapReduceCommand(map, reduce, finalize, entrada, salida));
	}

	def <E, S> mapReduceCommand(String map, String reduce, Class<E> entrada, Class<S> salida) {
		return MapReduce.build(map, reduce, MapReduce.OutputType.INLINE, null, entrada, salida);
	}

	def <E, S> mapReduceCommand(String map, String reduce, String finalize, Class<E> entrada, Class<S> salida) {
		val command = this.mapReduceCommand(map, reduce, entrada, salida);
		command.setFinalize(finalize);
		return command;
	}

	def setMongoCollection(JacksonDBCollection<T, String> mongoCollection) {
		this.mongoCollection = mongoCollection;
	}

	def getMongoCollection() {
		return mongoCollection;
	}

	def update(String id, T object) {
		mongoCollection.updateById(id, object)
	}

	def void actualizar(String id, T obj) {
		mongoCollection.updateById(id, obj)
	}

	def delete(String property, String value) {
		var query = new BasicDBObject()
		query.append(property, value)
		mongoCollection.remove(query)
	}

	def deleteAll() {
		mongoCollection.drop()
	}

	def find(String id) {
		mongoCollection.findOneById(id)
	}

	def find(String property, String value) {
		mongoCollection.findOne(DBQuery.is(property, value));

	}

	def getContents(Usuario usuario, Usuario usuario2, boolean sonAmigos, boolean esElMismo) {

		var queryUserNickname = DBQuery.is("nickname", usuario.nickname)
		var visibilityPostPublic = DBQuery.is("posts.visibility", Visibility.PUBLIC)

		var visibilityPostJustFriends = DBQuery.is("posts.visibility", Visibility.JUSTFRIENDS)

		var visibilityPostPrivate = DBQuery.is("posts.visibility", Visibility.PRIVATE)

		var visibilityCommentPublic = DBQuery.is("posts.comments.visibility", Visibility.PUBLIC)

		var visibilityCommentJustFriends = DBQuery.is("posts.comments.visibility", Visibility.JUSTFRIENDS)

		var visibilityCommentPrivate = DBQuery.is("posts.comments.visibility", Visibility.PRIVATE)

		var or = DBQuery.or(visibilityPostPublic, visibilityCommentPublic)
		if(esElMismo) {
			or = DBQuery.or(visibilityPostPrivate)
		}
		if(sonAmigos) {
			or = DBQuery.or(visibilityPostJustFriends)
		}
		var query = DBQuery.and(queryUserNickname, or)
		var perf = mongoCollection.findOne(query)
		var perfil = perf as Perfil
		perfil.posts.forEach [
			System.out.println(it.destino)
		]

		return perf
	}

}

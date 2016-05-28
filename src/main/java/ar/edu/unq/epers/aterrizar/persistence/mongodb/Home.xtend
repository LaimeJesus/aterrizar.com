package ar.edu.unq.epers.aterrizar.persistence.mongodb;

import java.util.List
import org.mongojack.DBQuery.Query
import org.mongojack.JacksonDBCollection
import org.mongojack.MapReduce
import org.mongojack.DBQuery
import com.mongodb.BasicDBObject

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
}

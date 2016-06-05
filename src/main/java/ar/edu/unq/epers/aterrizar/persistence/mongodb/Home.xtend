package ar.edu.unq.epers.aterrizar.persistence.mongodb;

import java.util.List
import org.mongojack.DBQuery.Query
import org.mongojack.JacksonDBCollection
import org.mongojack.MapReduce
import org.mongojack.DBQuery
import com.mongodb.BasicDBObject
import ar.edu.unq.epers.aterrizar.domain.redsocial.visibility.Visibility
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil
import org.mongojack.AggregationResult
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Home<T> {
	private JacksonDBCollection<T, String> mongoCollection;

	Class<T> entityType

	new(JacksonDBCollection<T, String> collection) {
		this.mongoCollection = collection
	}

	new(JacksonDBCollection<T, String> collection, Class<T> entity) {
		this.mongoCollection = collection
		this.entityType = entity
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

	//////////////////////////////////////////////////////////////
	//metodos creados para servicio
	//////////////////////////////////////////////////////////////
	def update(String id, T object) {
		mongoCollection.updateById(id, object)
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

	def List<T> find(Aggregation<T> aggregation) {
		new AggregationResult<T>(
			mongoCollection,
			mongoCollection.dbCollection.aggregate(aggregation.build),
			entityType
		).results
	}

	def Perfil getContents(String nick, List<Visibility> visibilities) {

		var agg = this.aggregate
		var matchNick = agg.match("nickname", nick)
		var projFilterNickYPosts = matchNick.project.rtn("nickname").rtn("posts")
		var postFiltrados = projFilterNickYPosts.filter("posts")

		var aggFiltrado = getListFilter(postFiltrados, visibilities, visibilities.size)

		//		var commProject = aggFiltrado.project.rtn("posts.comments")
		//		var projFilterComments = getListFilter(commProject, visibilities, visibilities.size)
		var lsres = aggFiltrado.execute

		//		var lsres = projFilterComments.execute
		var t = lsres.head as Perfil
		t
	}

	def Aggregation<T> getListFilter(Filter<T> filter, List<Visibility> visibilities, int s) {
		filter.or(visibilities.map[v|[Filter<T> f| f.eq("visibility", v.toString)]])
	}

	def aggregate() {
		new Aggregation(this)

	}

}

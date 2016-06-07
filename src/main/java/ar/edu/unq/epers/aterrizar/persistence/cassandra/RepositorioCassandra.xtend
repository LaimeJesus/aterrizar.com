package ar.edu.unq.epers.aterrizar.persistence.cassandra

import java.util.List
import ar.edu.unq.epers.aterrizar.utils.ArmadorDeDeclaraciones
import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.core.Cluster

@Accessors
abstract class RepositorioCassandra<T> {

	//repo
	Cluster cluster
	String ip
	ArmadorDeDeclaraciones creator

	String keyspace

	new() {
	}

	new(String ks) {

		//		var builder = Cluster.builder()
		//
		//		//127.0.1.
		//		//ip = newIp
		//		ip = "127.0.0.1"
		//
		//		//agrega la dir de ip del nodo
		//		builder.addContactPoint(ip)
		//
		//		//crea un cluster con ese builder
		//		cluster = builder.build()
		//
		//		//creo una nueva keyspace con keyspacetowrok
		//		keyspace = keyspaceToWork
		//
		//		createKEYSPACE(keyspaceToWork, "NetworkTopologyStrategy", "1")
		var b = Cluster.builder()
		b.addContactPoint("127.0.0.1")
		var c = b.build()
		cluster = c
		var query = "CREATE KEYSPACE " + ks + " WITH replication = {'class':'NetworkTopologyStrategy', 'replication_factor':1};"
		cluster.connect().execute(query)
		keyspace = ks
		}

	//devuelve una session luego de conectar el cluster
	def session() {
		cluster.connect(keyspace)
	}

	/*
	 * precondicion fields.length == types.length
	 */
	def createType(String name, List<String> fields, List<String> types) {
		var r = creator.zipWith(fields, types, " ")
		var query = creator.separar(r, ",")
		query = "CREATE TYPE " + name + " (" + query + ");"
		session.execute(query)
	}

	abstract def void createTable()

	def createTable(T object) {
		var query = normalQuery(object) + ";"
		session.execute(query)
	}

	def createTableWith(T object, String nameProperty, String idProperty) {
		var query = normalQuery(object) + " WITH " + nameProperty + "=" + "'" + idProperty + "';"
	}

	def normalQuery(T object) {
		var fields = fields(object)
		var types = types(object)
		var r = creator.zipWith(fields, types, " ")
		var fieldsAndTypes = creator.separar(r, ",")
		var query = "CREATE TABLE " + table() + " (" + fieldsAndTypes + ")"
		query
	}

	def abstract List<String> types(T t)

	/*
	 * solo crea keyspace simple si necesita alguna otro busque mas informacion
	 * strategies = NetworkTopologyStrategy, SimpleStrategy, OldNetworkTopologyStrategy
	 */
	def createKEYSPACE(String name, String strategy, String repFactor) {
		var query = "CREATE KEYSPACE " + name + " WITH replication = {'class':'" + strategy + "', 'replication_factor':" +
			repFactor + "}; "
		session.execute(query);
	}

	def useKeyspace(String ks) {
		keyspace = ks
	}

	def createIndex(String indexName, String field) {
		var query = "CREATE INDEX " + indexName + " ON " + table + "(" + field + ");"
		session.execute(query)
	}

	def void persist(T object) {

		//ejemplo query insert into
		//	var insert = "INSERT INTO emp (emp_id, emp_name, emp_city, emp_phone,  emp_sal) VALUES(1,'ram', 'Hyderabad', 9848022338, 50000);"
		var fields = fields(object)
		var values = values(object)
		var query = creator.armarInsert(table(), fields, values) + ';'
		session.execute(query)

	//exec	
	}

	abstract def String table()

	abstract def List<String> fields(T object)

	abstract def List<String> values(T object)

	def void update(T object, String field, String value) {

		//ejemplo query update
		//	var update = " UPDATE emp SET emp_city='Delhi',emp_sal=50000"
		var fields = fields(object)
		var values = values(object)
		var query = creator.armarUpdate(table(), fields, values, field, value) + ';'
		session.execute(query)

	//exec
	}

	def T get(String field, String value) {

		//	var select = "SELECT * FROM emp"
		var query = creator.armarSelect(table(), field, value) + ';'
		var r = session.execute(query)
		r.head as T

	//exec
	}

	def delete(String field, String value) {

		//	var delete = "DELETE FROM emp WHERE emp_id=3;";
		var query = creator.armarDelete(table, field, value) + ';'
		session.execute(query)

	//exec
	}
}

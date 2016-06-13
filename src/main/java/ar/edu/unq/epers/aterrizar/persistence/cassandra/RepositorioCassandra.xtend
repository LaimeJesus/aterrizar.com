package ar.edu.unq.epers.aterrizar.persistence.cassandra

import ar.edu.unq.epers.aterrizar.utils.ArmadorDeDeclaraciones
import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.Mapper
import com.datastax.driver.mapping.MappingManager

@Accessors
abstract class RepositorioCassandra<T> {

	ArmadorDeDeclaraciones creator
	CassandraConnector connector
	Mapper<T> mapper

	new() {
		connector = new CassandraConnector()
		creator = new ArmadorDeDeclaraciones
	}

	new(Class<T> t) {
		connector = new CassandraConnector()
		creator = new ArmadorDeDeclaraciones
		mapper = new MappingManager(connector.session).mapper(t)

	}

	def createSimpleKEYSPACE(String name, String repFactor) {
		var query = "CREATE KEYSPACE IF NOT EXISTS " + name + " WITH replication = {'class':'SimpleStrategy', 'replication_factor':" +
			repFactor + "}; "
		connector.execute(query)
	}

	def void persist(T object) {

		//ejemplo query insert into
		//	var insert = "INSERT INTO emp (emp_id, emp_name, emp_city, emp_phone,  emp_sal) VALUES(1,'ram', 'Hyderabad', 9848022338, 50000);"
		//		var fields = fields(object)
		//		var values = values(object)
		//		var query = creator.armarInsert(table(), fields, values) + ';'
		//		connector.execute(query)
		mapper.save(object)

	}

	def void update(T object) {

		//ejemplo query update
		//		var update = " UPDATE emp SET emp_city='Delhi',emp_sal=50000"
		//		var fields = fields(object)
		//		var values = values(object)
		//		var query = creator.armarUpdate(table(), fields, values, field, value) + ';'
		mapper.save(object)
	}

	def T get(String field, String value) {

		//	var select = "SELECT * FROM emp"
		//		var query = creator.armarSelect(table(), field, value) + ';'
		//		var r = connector.execute(query)
		//		r.head as T
		mapper.get(value) as T
	}

	def void delete(String field, String value) {

		//	var delete = "DELETE FROM emp WHERE emp_id=3;";
		//		var query = creator.armarDelete(table, field, value) + ';'
		//		connector.execute(query)
		mapper.delete(value)
	}

	def void clean() {
	}

}

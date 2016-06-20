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
		setConnector(new CassandraConnector())
		setCreator(new ArmadorDeDeclaraciones)
	}

	new(Class<T> t) {
		setConnector(new CassandraConnector())
		setCreator(new ArmadorDeDeclaraciones)
		setMapper(new MappingManager(connector.session).mapper(t))

	}

	def createSimpleKEYSPACE(String name, String repFactor) {
		var query = "CREATE KEYSPACE IF NOT EXISTS " + name + " WITH replication = {'class':'SimpleStrategy', 'replication_factor':" +
			repFactor + "}; "
		getConnector.execute(query)
	}

	def void persist(T object) {

		getMapper.save(object)
	}

	def void update(T object) {

		getMapper.save(object)
	}

	def T get(String field, String value) {

		getMapper.get(value) as T
	}

	def void delete(String field, String value) {

		getMapper.delete(value)
	}

}

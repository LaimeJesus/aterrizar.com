package ar.edu.unq.epers.aterrizar.persistence.cassandra

import com.datastax.driver.core.Cluster
import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.core.Session

@Accessors
class CassandraConnector {

	Cluster cluster
	String keyspace

	new() {
		cluster = Cluster.builder().addContactPoint("localhost").build()
		keyspace = null
	}

	new(String contactP) {
		cluster = Cluster.builder().addContactPoint(contactP).build()
		keyspace = null
	}

	def Session session() {
		if(keyspace != null) {
			return cluster.connect(keyspace)
		} else {
			return cluster.connect()
		}

	}
	def void close() {
		cluster.close()
	}

	def execute(String query) {
		var Session s = null
		try {
			s = session()
			s.execute(query)
		} finally {
			s.close()
		}
	}

}

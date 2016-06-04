package ar.edu.unq.epers.aterrizar.persistence.cassandra

import com.datastax.driver.core.Cluster

class RepositorioCassandra {
		//repo
	
	Cluster repo
	
	def void createCluster(){
		//creating a builder
		var builder = Cluster.builder()
		//agrega la dir de ip del nodo
		builder.addContactPoint("")
		//crea un cluster con ese builder
		repo = builder.build()
		
	}
	
	//devuelve una session luego de conectar el cluster
	def session(){
		repo.connect()
	}	
	//devuelve una session de la keyspace dada como argumento luego de conectar el cluster
	def session(String keyspace){
		repo.connect(keyspace)
	}
	
	def createTable(){
		
	}
	
	def addColumn(){
		
	}
	
	def deleteColumn(){
		
	}
	
	def persist(){
		//ejemplo query insert into
	var insert = "INSERT INTO emp (emp_id, emp_name, emp_city, emp_phone,  emp_sal) VALUES(1,'ram', 'Hyderabad', 9848022338, 50000);"
	}
	def update(){
		//ejemplo query update
	var update = " UPDATE emp SET emp_city='Delhi',emp_sal=50000"
	}
	def get(){
	var select = "SELECT * FROM emp"
	}
	def delete(){
	var delete = "DELETE FROM emp WHERE emp_id=3;";
	}
}
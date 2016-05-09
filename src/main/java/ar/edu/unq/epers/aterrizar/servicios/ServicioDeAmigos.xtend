package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.persistence.neo4j.RepositorioAmigos
import org.neo4j.graphdb.GraphDatabaseService

class ServicioDeAmigos {
	
	def void agregarAmigo(Usuario usuario, Usuario amigo){

	}
	
	def createHome(GraphDatabaseService graph){
		new RepositorioAmigos(graph)
	}
}
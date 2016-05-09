package ar.edu.unq.epers.aterrizar.persistence.neo4j

import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.aterrizar.domain.Usuario
import org.neo4j.graphdb.DynamicLabel
import ar.edu.unq.epers.aterrizar.domain.relaciones.TipoDeRelacion
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.Node

@Accessors
class RepositorioAmigos {
	GraphDatabaseService graph
	
	new(GraphDatabaseService g){
		graph = g
	}
	
	def crearNodo(Usuario usuario){
		val node = graph.createNode(usuarioLabel)
		node.setProperty("nickname", usuario.nickname)
		node.setProperty("idUsuario", usuario.idUsuario)
	}
	
	def usuarioLabel() {
		DynamicLabel.label("Usuario")
	}
	
	def eliminarNodo(Usuario u){
		val nodo = getNodo(u)
		nodo.relationships.forEach[delete]
		nodo.delete
	}
	
	def getNodo(Usuario usuario) {
		this.getNodo(usuario.nickname)
	}
	def getNodo(String nickname) {
		this.graph.findNodes(usuarioLabel, "nickname", nickname).head
	}
	
	def relacionar(Usuario relacionando, Usuario aRelacionar, TipoDeRelacion relacion){
		val nodoRelacionando = getNodo(relacionando)
		val nodoARelacionar = getNodo(aRelacionar)
		nodoRelacionando.createRelationshipTo(nodoARelacionar, relacion)
	}
	
	def getAmigos(Usuario u){
		val nodoUsuario = getNodo(u)
		val amigos = nodosRelacionados(nodoUsuario, TipoDeRelacion.AMIGO, Direction.INCOMING)
		amigos.map[toUsuario(it)].toSet
	}
	
	def toUsuario(Node node) {
		new Usuario => [
			nickname = node.getProperty("nickname") as String
			idUsuario = node.getProperty("idUsuario") as int
		]
	}
	
	
	def nodosRelacionados(Node node, TipoDeRelacion relacion, Direction direction) {
		node.getRelationships(relacion, direction).map[it.getOtherNode(node)]
	}
	
}
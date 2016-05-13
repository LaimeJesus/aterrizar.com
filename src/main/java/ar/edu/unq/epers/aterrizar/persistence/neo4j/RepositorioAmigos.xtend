package ar.edu.unq.epers.aterrizar.persistence.neo4j

import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.aterrizar.domain.Usuario
import org.neo4j.graphdb.DynamicLabel
import ar.edu.unq.epers.aterrizar.domain.relaciones.TipoDeRelacion
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.traversal.Uniqueness

@Accessors
class RepositorioAmigos {
	GraphDatabaseService graph
	
	new(GraphDatabaseService g){
		graph = g
	}
	
	//crear un nodo desde un usuario
	
	def crearNodo(Usuario usuario){
		val node = graph.createNode(usuarioLabel)
		node.setProperty("nickname", usuario.nickname)
		//node.setProperty("idUsuario", usuario.idUsuario)
	}
	
	//borrar un usuario
	
	def eliminarNodo(Usuario u){
		val nodo = getNodo(u)
		nodo.relationships.forEach[delete]
		nodo.delete
	}

	//definir un nodo como usuario
	
	def usuarioLabel() {
		DynamicLabel.label("Usuario")
	}

	//traer un usuario
	
	def getNodo(Usuario usuario) {
		this.getNodo(usuario.nickname)
	}
	def getNodo(String nickname) {
		this.graph.findNodes(usuarioLabel, "nickname", nickname).head
	}
	
	// relacionar usuarios por la relacion amigo
	def relacionarAmistad(Usuario usuario, Usuario amigo) {
		relacionar(usuario, amigo, TipoDeRelacion.AMIGO)
	}	

	def relacionar(Usuario relacionando, Usuario aRelacionar, TipoDeRelacion relacion){
		val nodoRelacionando = getNodo(relacionando)
		val nodoARelacionar = getNodo(aRelacionar)
		nodoRelacionando.createRelationshipTo(nodoARelacionar, relacion)
	}
	
	//todos mis amigos
	
	def getAmigos(Usuario u){
		val nodoUsuario = getNodo(u)
		val nodos = nodosRelacionados(nodoUsuario, TipoDeRelacion.AMIGO, Direction.OUTGOING)
		//puedo hacer mi propio toSet en el cual saco al nodo u, que no quiero que aparezca en amigos
		var amigos = nodos.map[toUsuario(it)].toSet
		amigos.forEach[
			System.out.println(it.nickname)
		]
		//no encontre el metodo para no agregarme en el recorrido
		amigos.removeIf([it.nickname.equals(u.nickname)])
		return amigos
	}
	
	//todos mis conocidos
	
	def getAmigosDeAmigos(Usuario u){
		val nodoUsuario = getNodo(u)
		val nodos = todosLosRelacionados(nodoUsuario, TipoDeRelacion.AMIGO, Direction.OUTGOING)
		//puedo hacer mi propio toSet en el cual saco al nodo u, que no quiero que aparezca en amigos
		val amigos = nodos.map[toUsuario(it)].toSet
		amigos.forEach[
			System.out.println(it.nickname)
		]
		//no encontre el metodo para no agregarme en el recorrido
		amigos.removeIf([it.nickname.equals(u.nickname)])
		return amigos
	}


	//transformar un nodo en un usuario	
	def toUsuario(Node node) {
		new Usuario => [
			nickname = node.getProperty("nickname") as String
			//idUsuario = node.getProperty("idUsuario") as Integer
		]
	}
	
	// conseguir los usuarios que esten relacionados por alguna relacion y viendo desde una direccion
	def nodosRelacionados(Node node, TipoDeRelacion relacion, Direction direction) {
		node.getRelationships(relacion, direction).map[it.getOtherNode(node)]
	}

	//no estoy seguro cual de las 2 formas es la que funciona voy a probar las 2
	def todosLosRelacionados(Node n, TipoDeRelacion r, Direction d){
//		val res = new ArrayList<Node>
		val traveler = graph.traversalDescription()
            .depthFirst()
            .relationships(r, d)
            .uniqueness(Uniqueness.NODE_GLOBAL);

    	val nodesInComponent = traveler.traverse(n).nodes();
    	return nodesInComponent
//si le quiero hacer algo al nodo que estoy recorriendo
//		for(Node current : traveler.traverse(n).nodes()){
//			res.add(current)
//		}
//		return res
	}

	
}
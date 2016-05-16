package ar.edu.unq.epers.aterrizar.persistence.neo4j

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.Usuario
import org.neo4j.graphdb.DynamicLabel
import ar.edu.unq.epers.aterrizar.domain.relaciones.TipoDeRelacion
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.Node
import ar.edu.unq.epers.aterrizar.exceptions.NoExisteObjectTException

@Accessors
class RepositorioAmigos extends RepositorioNeo4j<Usuario>{

	
	// relacionar usuarios por la relacion amigo
	def relacionarAmistad(Usuario user1, Usuario user2) {
		val enviando = getNodo(user1)
		val recibiendo = getNodo(user2)
		
		relacionar(enviando, recibiendo, TipoDeRelacion.AMIGO)
		relacionar(recibiendo, enviando, TipoDeRelacion.AMIGO)
	}	
	
	//todos mis amigos
	
	def getAmigos(Usuario u){
		val nodoUsuario = getNodo(u)
		val nodos = nodosRelacionados(nodoUsuario, TipoDeRelacion.AMIGO, Direction.OUTGOING)
		//puedo hacer mi propio toSet en el cual saco al nodo u, que no quiero que aparezca en amigos
		var amigos = nodos.map[toObject(it)].toSet
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
		val amigos = nodos.map[toObject(it)].toSet
		amigos.forEach[
			System.out.println(it.nickname)
		]
		return amigos
	}

	override agregarPropiedades(Node node, Usuario obj){
		node.setProperty("nickname", obj.nickname)
		//node.setProperty("idUsuario", usuario.idUsuario)
	}
		
	override objLabel() {
		DynamicLabel.label("Usuario")
	}
	
	override toObject(Node node) {
		new Usuario() => [
			nickname = node.getProperty("nickname") as String 
		]
	}
	
	override getNodo(Usuario obj) throws NoExisteObjectTException {
		graph.findNodes(objLabel, "nickname", obj.nickname).head
	}
	
}
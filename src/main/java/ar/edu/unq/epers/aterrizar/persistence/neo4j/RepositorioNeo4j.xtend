package ar.edu.unq.epers.aterrizar.persistence.neo4j

import org.neo4j.graphdb.Node
import org.neo4j.graphdb.RelationshipType
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Label
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.traversal.Uniqueness
import org.neo4j.graphdb.traversal.Evaluators
import ar.edu.unq.epers.aterrizar.exceptions.NoExisteObjectTException

abstract class RepositorioNeo4j<T> {
		GraphDatabaseService graph
	
	new(GraphDatabaseService g){
		graph = g
	}
	
	//crear un nodo desde un usuario
	
	def crearNodo(T obj){
		val node = graph.createNode(objLabel)
		agregarPropiedades(node, obj)
		node
	}
	def void eliminarNodo(T obj){
		val nodo = getNodo(obj)
		nodo.relationships.forEach[delete]
		nodo.delete
	}
	
	def abstract void agregarPropiedades(Node node, T obj)
	
	def abstract Label objLabel()
	
	def abstract Node getNodo(T obj) throws NoExisteObjectTException
	
	def abstract T toObject(Node node)
	
	// relacionar usuarios por la relacion amigo
	def relacionar(Node relacionando, Node aRelacionar, RelationshipType relacion){
		relacionando.createRelationshipTo(aRelacionar, relacion)
	}
	
	// conseguir los usuarios que esten relacionados por alguna relacion y viendo desde una direccion
	def nodosRelacionados(Node node, RelationshipType relacion, Direction direction) {
		node.getRelationships(relacion, direction).map[it.getOtherNode(node)]
	}

	//no estoy seguro cual de las 2 formas es la que funciona voy a probar las 2
	def todosLosRelacionados(Node n, RelationshipType r, Direction d){
//		val res = new ArrayList<Node>
//		val traveler = graph.traversalDescription()
//            .depthFirst()
//            .relationships(r, d)
//            .uniqueness(Uniqueness.NODE_GLOBAL);
//si le quiero hacer algo al nodo que estoy recorriendo
//		for(Node current : traveler.traverse(n).nodes()){
//			res.add(current)
//		}
//		return res

		val traveler = graph.traversalDescription()
            .depthFirst()
            .relationships(r, d)
            .evaluator(Evaluators.excludeStartPosition)
            .uniqueness(Uniqueness.NODE_GLOBAL);

    	val nodesInComponent = traveler.traverse(n).nodes();
    	return nodesInComponent

	}
	
}
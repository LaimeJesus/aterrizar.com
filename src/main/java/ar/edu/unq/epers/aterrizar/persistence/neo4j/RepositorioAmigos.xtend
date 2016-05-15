package ar.edu.unq.epers.aterrizar.persistence.neo4j

import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.aterrizar.domain.Usuario
import org.neo4j.graphdb.DynamicLabel
import ar.edu.unq.epers.aterrizar.domain.relaciones.TipoDeRelacion
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.traversal.Uniqueness
import ar.edu.unq.epers.aterrizar.domain.Mail
import ar.edu.unq.epers.aterrizar.domain.relaciones.TipoDeMensajes
import org.neo4j.graphdb.RelationshipType
import org.neo4j.graphdb.traversal.Evaluators

@Accessors
class RepositorioAmigos {
	GraphDatabaseService graph
	
	RepositorioMensajesEntreAmigos repoMensajes
	
	new(GraphDatabaseService g){
		graph = g
		repoMensajes = new RepositorioMensajesEntreAmigos(g)
	}
	
	// relacionar usuarios por la relacion amigo
	def relacionarAmistad(Usuario usuario, Usuario amigo) {
		relacionar(usuario, amigo, TipoDeRelacion.AMIGO)
		relacionar(amigo, usuario, TipoDeRelacion.AMIGO)
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
		return amigos
	}
	
	def relacionar(Usuario relacionando, Usuario aRelacionar, TipoDeRelacion relacion){
		val nodoRelacionando = getNodo(relacionando)
		val nodoARelacionar = getNodo(aRelacionar)
		relacionar(nodoRelacionando,nodoARelacionar, relacion)
	}
	

	///////////////////////////////////////////////////////////////////////////
	//lado de mails
	//hay un traspase de mensajes demas porque antes este lo mandaba al repo de mails que tenia como variable 
	//esto lo hacia para compartir el mismo graphdbservice pero no funcionaba
	///////////////////////////////////////////////////////////////////////////
	def eliminarMensajes(Mail mail) {
		eliminarNodo(mail)
	}
	
	def enviadosPor(Usuario usuario) {
		mailsEnviadosPor(usuario)
	}
	
	def recibidosPor(Usuario usuario) {
		mailsRecibidosPor(usuario)
	}
	
	def enviarMensaje(Usuario emisor, Mail mail, Usuario receptor) {
		relacionEnviarMensaje(emisor, mail, receptor)
	}
	
	def eliminarMensajesDeUsuario(Usuario usuario) {
		eliminarMensajesEnviados(usuario)
		eliminarMensajesRecibidos(usuario)
	}

	def eliminarMensajesEnviados(Usuario u){
		val nodoUsuario = getNodo(u)
		nodosRelacionados(nodoUsuario,TipoDeMensajes.EMISOR, Direction.OUTGOING).forEach[delete]		
	}
	
	def eliminarMensajesRecibidos(Usuario u){
		val nodoUsuario = getNodo(u)
		nodosRelacionados(nodoUsuario,TipoDeMensajes.RECEPTOR, Direction.INCOMING).forEach[delete]		
	}

	def relacionEnviarMensaje(Usuario emisor, Mail mailAEnviar, Usuario receptor){
		val nodoEmisor = getNodo(emisor)
		val nodoMensaje = crearNodo(mailAEnviar)
		val nodoReceptor = getNodo(receptor)
		relacionar(nodoEmisor, nodoMensaje, TipoDeMensajes.EMISOR)
		relacionar(nodoMensaje, nodoReceptor, TipoDeMensajes.RECEPTOR)
	}
	
	def mailsEnviadosPor(Usuario usuario) {
		val nodoEmisor = getNodo(usuario)
		nodosRelacionados(nodoEmisor, TipoDeMensajes.EMISOR, Direction.OUTGOING).map[toMail(it)].toSet
	}
	def mailsRecibidosPor(Usuario usuario) {
		val nodoReceptor = getNodo(usuario)
		nodosRelacionados(nodoReceptor, TipoDeMensajes.RECEPTOR, Direction.INCOMING).map[toMail(it)].toSet
	}
	
	///////////////////////////////////////////////////////////////////////////
	//lado que se puede abstraer
	///////////////////////////////////////////////////////////////////////////
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

		val traveler = graph.traversalDescription()
            .depthFirst()
            .relationships(r, d)
            .evaluator(Evaluators.excludeStartPosition)
            .uniqueness(Uniqueness.NODE_GLOBAL);

    	val nodesInComponent = traveler.traverse(n).nodes();
    	return nodesInComponent

	}
	
	def crearNodo(Usuario usuario){
		val node = graph.createNode(usuarioLabel)
		agregarPropiedades(node, usuario)
		node
	}
	def crearNodo(Mail obj){
		val node = graph.createNode(mailLabel)
		agregarPropiedades(node, obj)
		node
	}
	def void borrarRelaciones(Node nodo){
		nodo.relationships.forEach[delete]
		nodo.delete
	}
	def eliminarNodo(Mail obj){
		val nodo = getNodo(obj)
		borrarRelaciones(nodo)
	}
	def eliminarNodo(Usuario u){
		val nodo = getNodo(u)
		borrarRelaciones(nodo)
	}
	
	def agregarPropiedades(Node node, Usuario obj){
		node.setProperty("nickname", obj.nickname)
		//node.setProperty("idUsuario", usuario.idUsuario)
		
	}
	
	def agregarPropiedades(Node node, Mail obj){
		node.setProperty("emisor", obj.from)
		node.setProperty("receptor", obj.to)
		node.setProperty("body", obj.body)
		node.setProperty("subject", obj.subject)
		node.setProperty("idMail", obj.idMail)
	}
	
	def toMail(Node node) {
		new Mail() => [
			from = node.getProperty("emisor") as String
			to = node.getProperty("receptor") as String
			body = node.getProperty("body") as String
			subject = node.getProperty("subject") as String
			idMail = node.getProperty("idMail") as Integer
		]
	}
	def toUsuario(Node node) {
		new Usuario => [
			nickname = node.getProperty("nickname") as String
			//idUsuario = node.getProperty("idUsuario") as Integer
		]
	}

	def usuarioLabel() {
		DynamicLabel.label("Usuario")
	}
		
	def mailLabel() {
		DynamicLabel.label("Mensaje")
	}

	def getNodo(Mail obj) throws Exception{
		graph.findNodes(mailLabel, "idMensaje", obj.idMail).head			
	}

	def getNodo(Usuario usuario) throws Exception{
		graph.findNodes(usuarioLabel, "nickname", usuario.nickname).head
	}
}
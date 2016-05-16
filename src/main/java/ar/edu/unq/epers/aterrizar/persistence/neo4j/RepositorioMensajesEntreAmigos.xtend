package ar.edu.unq.epers.aterrizar.persistence.neo4j

import org.neo4j.graphdb.Node
import org.neo4j.graphdb.DynamicLabel
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.relaciones.TipoDeMensajes
import ar.edu.unq.epers.aterrizar.domain.Mail
import org.neo4j.graphdb.Direction

//no se puede usar junto con repoamigos, no entiendo xq no pueden compartir el mismo graph
@Accessors
class RepositorioMensajesEntreAmigos extends RepositorioNeo4j<Mail> {
		
	override objLabel() {
		DynamicLabel.label("Mensaje")
	}
	override getNodo(Mail obj){
		graph.findNodes(objLabel, "idMensaje", obj.idMail).head			
	}
	
	def getUserNode(Usuario u) throws Exception{
		try{
			graph.findNodes(DynamicLabel.label("Usuario"), "nickname", u.nickname).head
		}catch(Exception e){
			System.out.println("No hay head")
		}
	}
	
	override toObject(Node node) {
		new Mail() => [
			from = node.getProperty("emisor") as String
			to = node.getProperty("receptor") as String
			body = node.getProperty("body") as String
			subject = node.getProperty("subject") as String
			idMail = node.getProperty("idMail") as Integer
		]
	}
	
	override agregarPropiedades(Node node, Mail obj){
		node.setProperty("emisor", obj.from)
		node.setProperty("receptor", obj.to)
		node.setProperty("body", obj.body)
		node.setProperty("subject", obj.subject)
		node.setProperty("idMail", obj.idMail)
	}
	
	def relacionEnviarMensaje(Usuario emisor, Mail mailAEnviar, Usuario receptor){
		val nodoEmisor = getUserNode(emisor)
		val nodoMensaje = crearNodo(mailAEnviar)
		val nodoReceptor = getUserNode(receptor)
		
		relacionar(nodoEmisor, nodoMensaje, TipoDeMensajes.EMISOR)
		relacionar(nodoMensaje, nodoReceptor, TipoDeMensajes.RECEPTOR)
	}
	
	def mailsEnviadosPor(Usuario usuario) {
		val nodoEmisor = getUserNode(usuario)
		nodosRelacionados(nodoEmisor, TipoDeMensajes.EMISOR, Direction.OUTGOING).map[toObject(it)].toSet
	}
	def mailsRecibidosPor(Usuario usuario) {
		val nodoReceptor = getUserNode(usuario)
		nodosRelacionados(nodoReceptor, TipoDeMensajes.RECEPTOR, Direction.INCOMING).map[toObject(it)].toSet
	}
	def eliminarMensajes(Mail mail) {
		eliminarNodo(mail)
	}
		
	def eliminarMensajesDeUsuario(Usuario usuario) {
		eliminarMensajesEnviados(usuario)
		eliminarMensajesRecibidos(usuario)
	}

	def eliminarMensajesEnviados(Usuario u){
		val nodoUsuario = getUserNode(u)
		nodosRelacionados(nodoUsuario,TipoDeMensajes.EMISOR, Direction.OUTGOING).forEach[delete]		
	}
	
	def eliminarMensajesRecibidos(Usuario u){
		val nodoUsuario = getUserNode(u)
		nodosRelacionados(nodoUsuario,TipoDeMensajes.RECEPTOR, Direction.INCOMING).forEach[delete]		
	}

}
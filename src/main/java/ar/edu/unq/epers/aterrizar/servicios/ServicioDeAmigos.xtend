package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.persistence.neo4j.RepositorioAmigos
import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.aterrizar.persistence.neo4j.GraphServiceRunner
import java.util.List
import ar.edu.unq.epers.aterrizar.persistence.neo4j.RepositorioMensajesEntreAmigos
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.mensajes.Mail

@Accessors
class ServicioDeAmigos {

	ServicioDeRegistroDeUsuarios servicioDeUsuarios

	new(ServicioDeRegistroDeUsuarios s) {
		servicioDeUsuarios = s
	}

	//falta agregar al servicio de usuarios
	def void agregarAmigo(Usuario usuario, Usuario amigo) {
		servicioDeUsuarios.isRegistrado(usuario)
		servicioDeUsuarios.isRegistrado(amigo)
		
		GraphServiceRunner::run [
			createHome(it).relacionarAmistad(usuario, amigo)
			null
		]
	}

	def List<Usuario> consultarAmigos(Usuario u) {
		servicioDeUsuarios.isRegistrado(u)

		GraphServiceRunner::run [
			val amigos = createHome(it).getAmigos(u)
			amigos.toList
		]
	}

	////////////////////////////////////////////////////////
	//mails
	////////////////////////////////////////////////////////
	def void enviarMensajeAUnUsuario(Usuario emisor, Usuario receptor, Mail m) {
		servicioDeUsuarios.isRegistrado(emisor)
		servicioDeUsuarios.isRegistrado(receptor)
		GraphServiceRunner::run [
			crearRepoMails(it).relacionEnviarMensaje(emisor, m, receptor)
		]
	}

	def List<Mail> buscarMailsEnviados(Usuario u) {
		servicioDeUsuarios.isRegistrado(u)
		GraphServiceRunner::run [
			crearRepoMails(it).mailsEnviadosPor(u).toList
		]
	}

	def List<Mail> buscarMailsRecibidos(Usuario u) {
		servicioDeUsuarios.isRegistrado(u)
		GraphServiceRunner::run [
			crearRepoMails(it).mailsRecibidosPor(u).toList
		]
	}

	////////////////////////////////////////////////////////
	//
	////////////////////////////////////////////////////////
	//funciona
	def List<Usuario> consultarMisConocidos(Usuario u) {
		servicioDeUsuarios.isRegistrado(u)

		GraphServiceRunner::run [
			val todosMisConocidos = createHome(it).getAmigosDeAmigos(u)
			todosMisConocidos.toList
		]
	}

	def consultarACuantoConozco(Usuario u) {

		consultarMisConocidos(u).length
	}

	////////////////////////////////////////////////////////
	def createHome(GraphDatabaseService graph) {
		new RepositorioAmigos(graph)
	}

	////////////////////////////////////////////////////////
	//mails
	////////////////////////////////////////////////////////	
	def crearRepoMails(GraphDatabaseService graph) {
		new RepositorioMensajesEntreAmigos(graph)
	}

	def eliminarUsuarioDeAmigos(Usuario usuario) {
		GraphServiceRunner::run [
			createHome(it).eliminarNodo(usuario)
			null
		]
	}

	def crearUsuarioDeAmigos(Usuario usuario) {
		GraphServiceRunner::run [
			createHome(it).crearNodo(usuario)
			null
		]
	}
	
	////////////////////////////////////////////////////////
	//mails
	////////////////////////////////////////////////////////	
	def eliminarMail(Mail m) {
		GraphServiceRunner::run [
			crearRepoMails(it).eliminarNodo(m)
			null
		]
	}

	def eliminarMailsDeUsuario(Usuario usuario) {
		GraphServiceRunner::run [
			crearRepoMails(it).eliminarMensajesDeUsuario(usuario)
			null
		]
	}
	
	def sonAmigos(Usuario usuario, Usuario usuario2) {
		servicioDeUsuarios.isRegistrado(usuario)
		servicioDeUsuarios.isRegistrado(usuario2)
		GraphServiceRunner::run[
			createHome(it).sonAmigos(usuario, usuario2)
		]
	}

}

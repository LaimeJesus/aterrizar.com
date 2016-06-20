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
		setServicioDeUsuarios(s)
	}

	//falta agregar al servicio de usuarios
	def void agregarAmigo(Usuario usuario, Usuario amigo) {
		validarUsuarios(usuario, amigo)

		GraphServiceRunner::run [
			createHome(it).relacionarAmistad(usuario, amigo)
			null
		]
	}

	def void validarUsuarios(Usuario usuario, Usuario usr) {
		getServicioDeUsuarios.isRegistrado(usuario)
		getServicioDeUsuarios.isRegistrado(usr)

	}

	def List<Usuario> consultarAmigos(Usuario u) {
		validarUsuario(u)
		

		GraphServiceRunner::run [
			val amigos = createHome(it).getAmigos(u)
			amigos.toList
		]
	}
	
	def void validarUsuario(Usuario usuario) {
		getServicioDeUsuarios.isRegistrado(usuario)
	}

	////////////////////////////////////////////////////////
	//mails
	////////////////////////////////////////////////////////
	def void enviarMensajeAUnUsuario(Usuario emisor, Usuario receptor, Mail m) {
		validarUsuarios(emisor, receptor)
		GraphServiceRunner::run [
			crearRepoMails(it).relacionEnviarMensaje(emisor, m, receptor)
		]
	}

	def List<Mail> buscarMailsEnviados(Usuario u) {
		validarUsuario(u)
		GraphServiceRunner::run [
			crearRepoMails(it).mailsEnviadosPor(u).toList
		]
	}

	def List<Mail> buscarMailsRecibidos(Usuario u) {
		validarUsuario(u)
		GraphServiceRunner::run [
			crearRepoMails(it).mailsRecibidosPor(u).toList
		]
	}

	////////////////////////////////////////////////////////
	//
	////////////////////////////////////////////////////////
	//funciona
	def List<Usuario> consultarMisConocidos(Usuario u) {
		validarUsuario(u)

		GraphServiceRunner::run [
			val todosMisConocidos = createHome(it).getAmigosDeAmigos(u)
			todosMisConocidos.toList
		]
	}

	def int consultarACuantoConozco(Usuario u) {
		consultarMisConocidos(u).length
	}

	////////////////////////////////////////////////////////
	def RepositorioAmigos createHome(GraphDatabaseService graph) {
		new RepositorioAmigos(graph)
	}

	////////////////////////////////////////////////////////
	//mails
	////////////////////////////////////////////////////////	
	def RepositorioMensajesEntreAmigos crearRepoMails(GraphDatabaseService graph) {
		new RepositorioMensajesEntreAmigos(graph)
	}

	def void eliminarUsuarioDeAmigos(Usuario usuario) {
		GraphServiceRunner::run [
			createHome(it).eliminarNodo(usuario)
			null
		]
	}

	def void crearUsuarioDeAmigos(Usuario usuario) {
		GraphServiceRunner::run [
			createHome(it).crearNodo(usuario)
			null
		]
	}

	////////////////////////////////////////////////////////
	//mails
	////////////////////////////////////////////////////////	
	def void eliminarMail(Mail m) {
		GraphServiceRunner::run [
			crearRepoMails(it).eliminarNodo(m)
			null
		]
	}

	def void eliminarMailsDeUsuario(Usuario usuario) {
		GraphServiceRunner::run [
			crearRepoMails(it).eliminarMensajesDeUsuario(usuario)
			null
		]
	}

	def boolean sonAmigos(Usuario usuario, Usuario usuario2) {
		validarUsuarios(usuario, usuario2)
		GraphServiceRunner::run [
			createHome(it).sonAmigos(usuario, usuario2)
		]
	}

}

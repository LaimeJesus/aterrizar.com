package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.persistence.neo4j.RepositorioAmigos
import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.aterrizar.persistence.neo4j.GraphServiceRunner
import java.util.List
import ar.edu.unq.epers.aterrizar.domain.Mail
import ar.edu.unq.epers.aterrizar.persistence.neo4j.RepositorioMensajesEntreAmigos

class ServicioDeAmigos {
	
	ServicioDeRegistroDeUsuarios servicioDeUsuarios
	
	new(ServicioDeRegistroDeUsuarios s){
		servicioDeUsuarios = s
	}
	
	
	//falta agregar al servicio de usuarios
	def void agregarAmigo(Usuario usuario, Usuario amigo){
		
		
		val u = servicioDeUsuarios.traerUsuarioPorNickname(usuario.nickname)
		val a = servicioDeUsuarios.traerUsuarioPorNickname(amigo.nickname)
		
		GraphServiceRunner::run[
			createHome(it).relacionarAmistad(u, a)
			null
		]
	}
	
	//funciona
	def List<Usuario> consultarAmigos(Usuario u){ 

		val usuario = servicioDeUsuarios.traerUsuarioPorNickname(u.nickname)


		GraphServiceRunner::run[
		val amigos = createHome(it).getAmigos(usuario)
		amigos.toList
		]
	}
	////////////////////////////////////////////////////////
	//mails
	////////////////////////////////////////////////////////
	def void enviarMensajeAUnUsuario(Usuario emisor, Usuario receptor, Mail m){
		GraphServiceRunner::run[
			crearRepoMails(it).relacionEnviarMensaje(emisor, m, receptor)
		]
	}
	
	def List<Mail> buscarMailsEnviados(Usuario u){
		GraphServiceRunner::run[
			crearRepoMails(it).mailsEnviadosPor(u).toList
		]
	}

	def List<Mail> buscarMailsRecibidos(Usuario u){
		GraphServiceRunner::run[
			crearRepoMails(it).mailsRecibidosPor(u).toList
		]
	}

	////////////////////////////////////////////////////////
	//
	////////////////////////////////////////////////////////
	
	//funciona
	def List<Usuario> consultarMisConocidos(Usuario u){
		
		val usuario = servicioDeUsuarios.traerUsuarioPorNickname(u.nickname)
		
		GraphServiceRunner::run[
			val todosMisConocidos = createHome(it).getAmigosDeAmigos(usuario)
			todosMisConocidos.toList
		]
	}

	def consultarACuantoConozco(Usuario u){
		consultarMisConocidos(u).length
	}

	////////////////////////////////////////////////////////

	def createHome(GraphDatabaseService graph){
		new RepositorioAmigos(graph)
	}

	////////////////////////////////////////////////////////
	//mails
	////////////////////////////////////////////////////////	

	def crearRepoMails(GraphDatabaseService graph){
		new RepositorioMensajesEntreAmigos(graph)
	}
	
	def eliminarUsuarioDeAmigos(Usuario usuario) {
		GraphServiceRunner::run[
			createHome(it).eliminarNodo(usuario)
			null
		]
	}
	
	def crearUsuarioDeAmigos(Usuario usuario) {
		GraphServiceRunner::run[
			createHome(it).crearNodo(usuario)
			null
		]		
	}
	////////////////////////////////////////////////////////
	//mails
	////////////////////////////////////////////////////////	

	def eliminarMail(Mail m){
		GraphServiceRunner::run[
			crearRepoMails(it).eliminarNodo(m)
			null
		]
	}
	def eliminarMailsDeUsuario(Usuario usuario) {
		GraphServiceRunner::run[
			crearRepoMails(it).eliminarMensajesDeUsuario(usuario)
			null
		]
	}
	
}
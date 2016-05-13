package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.persistence.neo4j.RepositorioAmigos
import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.aterrizar.persistence.neo4j.GraphServiceRunner
import java.util.List

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
	
	//funciona
	def List<Usuario> consultarMiConexion(Usuario u){
		
		val usuario = servicioDeUsuarios.traerUsuarioPorNickname(u.nickname)
		
		GraphServiceRunner::run[
			val todosMisConocidos = createHome(it).getAmigosDeAmigos(usuario)
			todosMisConocidos.toList
		]
	}
	
	def consultarACuantoConozco(Usuario u){
		consultarMiConexion(u).length - 1
	}
	
	def createHome(GraphDatabaseService graph){
		new RepositorioAmigos(graph)
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
	
}
package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.persistence.mongodb.Home
import ar.edu.unq.epers.aterrizar.domain.Perfil
import ar.edu.unq.epers.aterrizar.persistence.mongodb.SistemDB
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.Post
import org.mongojack.DBQuery
import ar.edu.unq.epers.aterrizar.domain.Comment

class ServicioDePerfiles {
	
	Home<Perfil> repositorioDePerfiles
	
	ServicioDeRegistroDeUsuarios servicioDeUsuarios
	
//    Como usuario quiero poder agregar destinos a los que fui.

	new(ServicioDeRegistroDeUsuarios s){
		servicioDeUsuarios = s
		repositorioDePerfiles = SistemDB.instance().collection(Perfil)
	}

	def agregarDestino(){}

	def agregarPost(Usuario u, Post p){
		val perfil = getPerfil(u)
		perfil.addPost(p)
		updatePerfil(perfil)
	}
	

//    Como usuario quiero a cada destino poder hacerle comentarios, establecer “Me Gusta” o “No me gusta”
	
	def comentarPost(Usuario u, Post p, Comment c){
		val perfil = getPerfil(u)
		perfil.commentToPost(p,c)
		updatePerfil(perfil)
	}
	
	def meGusta(Usuario u, Post p){
		val perfil = getPerfil(u)
		perfil.agregarMeGusta(p)
		updatePerfil(perfil)
	}
	
	def noMeGusta(Usuario u, Post p){
		val perfil = getPerfil(u)
		perfil.agregarNoMeGusta(p)
		updatePerfil(perfil)
	}

	def meGusta(Usuario u, Post p, Comment c){
		val perfil = getPerfil(u)
		perfil.agregarMeGusta(p, c)
		updatePerfil(perfil)
	}
	
	def noMeGusta(Usuario u, Post p, Comment c){
		val perfil = getPerfil(u)
		perfil.agregarNoMeGusta(p, c)
		updatePerfil(perfil)
	}

//    Como usuario quiero a cada destino y comentario establecerle un nivel de visibilidad, privado, público y solo amigos.
	def cambiarAPublico(Usuario u, Post p){
		val perfil = getPerfil(u)
		perfil.configVisibilityIntoPublic(p)
		updatePerfil(perfil)
	}
	def cambiarAPublico(Usuario u, Post p, Comment c){
		val perfil = getPerfil(u)
		perfil.configVisibilityIntoPublic(p, c)
		updatePerfil(perfil)
	}
	
	def cambiarAPrivado(Usuario u, Post p){
		val perfil = getPerfil(u)
		perfil.configVisibilityIntoPrivate(p)
		updatePerfil(perfil)
		
	}
	def cambiarAPrivado(Usuario u, Post p, Comment c){
		val perfil = getPerfil(u)
		perfil.configVisibilityIntoPrivate(p, c)
		updatePerfil(perfil)
	}
	
	def cambiarASoloAmigos(Usuario u, Post p){
		val perfil = getPerfil(u)
		perfil.configVisibilityIntoJustFriends(p)
		updatePerfil(perfil)
		
	}
	def cambiarASoloAmigos(Usuario u, Post p, Comment c){
		val perfil = getPerfil(u)
		perfil.configVisibilityIntoJustFriends(p,c)
		updatePerfil(perfil)
	}
	
//    Como usuario quiero poder ver el perfil público de otro usuario, viendo lo que me corresponde según si soy amigo o no.

	def Perfil verPerfil(Usuario elQueQuiereVer, Usuario aQuienQuiereVer){
		val perfilQue = getPerfil(elQueQuiereVer)
		val perfilQuien = getPerfil(aQuienQuiereVer)
		perfilQue.getContents(perfilQuien)
	}
	
	////////////////////////////////////////////////////////////////////////////////
	//utilities
	////////////////////////////////////////////////////////////////////////////////
	def getPerfil(Usuario usuario) throws Exception{
		repositorioDePerfiles.find(DBQuery.is("nickname", usuario.nickname)).get(0)
	}
	
	def updatePerfil(Perfil perfil) {
		repositorioDePerfiles.insert(perfil)
	}
	
	
	
}
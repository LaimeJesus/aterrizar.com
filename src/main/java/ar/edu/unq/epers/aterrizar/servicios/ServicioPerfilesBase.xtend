package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.redsocial.DestinoPost
import ar.edu.unq.epers.aterrizar.exceptions.NoPuedeAgregarPostException
import ar.edu.unq.epers.aterrizar.domain.redsocial.Comment

interface ServicioPerfilesBase {
	def void agregarPost(Usuario u, DestinoPost p) throws NoPuedeAgregarPostException
	
	def void comentarPost(Usuario u, DestinoPost p, Comment c)
	
	def void meGusta(Usuario usuarioALikear, Usuario usuarioLikeando, DestinoPost p)
	
	def void noMeGusta(Usuario aLikear, Usuario likeando, DestinoPost p)
	
	
}
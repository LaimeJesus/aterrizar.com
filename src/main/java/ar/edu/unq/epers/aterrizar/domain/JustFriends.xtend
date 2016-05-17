package ar.edu.unq.epers.aterrizar.domain

import ar.edu.unq.epers.aterrizar.servicios.ServicioDeAmigos
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeRegistroDeUsuarios

@Accessors
class JustFriends extends Visibility{
	
	ServicioDeAmigos servicioDeAmigos
	ServicioDeRegistroDeUsuarios servicioDeUsuarios
	
	override puedeVer(Perfil owner, Perfil asking) {
		var ownerUser = servicioDeUsuarios.traerUsuarioPorNickname(owner.username)
		var askingUser = servicioDeUsuarios.traerUsuarioPorNickname(asking.username)		
		servicioDeAmigos.consultarAmigos(ownerUser).contains(askingUser)
	}
	
}
package ar.edu.unq.epers.aterrizar.domain.redsocial

import ar.edu.unq.epers.aterrizar.servicios.ServicioDeAmigos
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeRegistroDeUsuarios

@Accessors
class JustFriends extends Visibility{
	
	ServicioDeAmigos servicioDeAmigos
	ServicioDeRegistroDeUsuarios servicioDeUsuarios
	
	override puedeVer(Perfil owner, Perfil asking) {
		var ownerUser = servicioDeUsuarios.traerUsuarioPorNickname(owner.nickname)
		var askingUser = servicioDeUsuarios.traerUsuarioPorNickname(asking.nickname)		
		servicioDeAmigos.consultarAmigos(ownerUser).contains(askingUser)
	}
	
}

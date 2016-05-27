package ar.edu.unq.epers.aterrizar.domain.redsocial

class Private extends Visibility{
	
	override puedeVer(Perfil duenio, Perfil preguntando) {
		duenio.nickname.equals(preguntando.nickname)
	}
	
	
}

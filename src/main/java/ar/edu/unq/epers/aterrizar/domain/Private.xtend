package ar.edu.unq.epers.aterrizar.domain

class Private extends Visibility{
	
	override puedeVer(Perfil duenio, Perfil preguntando) {
		duenio.nickname.equals(preguntando.nickname)
	}
	
	
}
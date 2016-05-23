package ar.edu.unq.epers.aterrizar.domain.redsocial

abstract class Visibility {
	
	abstract def boolean puedeVer(Perfil duenio, Perfil preguntando)
}

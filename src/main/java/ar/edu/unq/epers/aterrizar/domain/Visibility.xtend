package ar.edu.unq.epers.aterrizar.domain

abstract class Visibility {
	
	abstract def boolean puedeVer(Perfil duenio, Perfil preguntando)
}
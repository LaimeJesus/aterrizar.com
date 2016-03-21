package ar.edu.unq.epers.aterrizar.persistence

interface Repositorio {
	def void persistir(Object obj)
	
	def void borrar(Object obj)
	
	def Object traer(Object obj)
	
	def boolean contiene(Object obj)
}
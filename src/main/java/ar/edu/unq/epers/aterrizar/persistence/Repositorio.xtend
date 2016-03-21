package ar.edu.unq.epers.aterrizar.persistence

interface Repositorio<T> {
	def void persistir(T obj)
	
	def void borrar(T obj)
	
	def T traer(T obj)
	
	def boolean contiene(T obj, String field)
	
	def void actualizar(T obj)
	
	def void objectNotFoundError(T obj) throws Exception
}
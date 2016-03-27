package ar.edu.unq.epers.aterrizar.persistence


interface Repositorio<T> {
	def void persistir(T obj)
	
	def void borrar(T obj, String campo, String valor)
	
	def T traer(T obj, String field, String value)
	
	def boolean contiene(T obj, String field, String value)
	
	def void actualizar(T obj, String field, String unique_value)
	
	def void objectNotFoundError(T obj) throws Exception
}
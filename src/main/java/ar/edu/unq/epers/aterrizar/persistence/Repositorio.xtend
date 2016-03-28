package ar.edu.unq.epers.aterrizar.persistence


interface Repositorio<T> {
	def void persistir(T obj)
	
	def void borrar(T obj, String campo, String valor)
	
	def T traer(String field, String value)
	
	def boolean contiene(String field, String value)
	
	def void actualizar(T obj, String field, String unique_value)
	
	def void objectNotFoundError() throws Exception
}
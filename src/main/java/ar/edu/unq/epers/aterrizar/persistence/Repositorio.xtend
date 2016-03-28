package ar.edu.unq.epers.aterrizar.persistence

import java.sql.DriverManager
import java.sql.Connection
import java.util.List
import java.sql.ResultSet
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Repositorio<T> {
	
	protected Connection connection
	
	def abstract void persistir(T obj)
	
	def abstract void borrar(String campo, String valor)
	
	def abstract T traer(String field, String value)
	
	def abstract boolean contiene(String field, String value)
	
	def abstract void actualizar(T obj, String field, String unique_value)
	
	def abstract void objectNotFoundError() throws Exception
	
	def abstract List<String> campos()
	
	def abstract List<String> valores(T obj)
	
	def abstract T armarObjeto(ResultSet s)
	
	//jdbc:mysql://<host>:<port>/<database_name> 
	def getConnection(String url, String user, String password) {
		Class.forName("com.mysql.jdbc.Driver");
		return DriverManager.getConnection(url, user, password)
	}
	def cerrarConeccion(){
		connection.close()
	}
	def conectarABDConMySql(String url, String user, String password){
		connection = this.getConnection(url, user, password)
	}
}
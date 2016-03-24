package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.exceptions.usuarioNoEstaEnElServicioException
import java.sql.DriverManager
import java.sql.Connection
import org.eclipse.xtext.xbase.lib.Functions.Function1
import java.sql.ResultSet


class RepositorioUsuario implements Repositorio<Usuario>{
	
	Connection connection = this.getConnection()
	
	//insert into tabla values (valores)
	override def void persistir(Usuario usr) {
		var declaracion = this.armarDeclaracionInsert()
		val ps = connection.prepareStatement(declaracion)
		ps.setString(1, usr.nombre)
		ps.setString(2, usr.apellido)
		ps.setString(3, usr.nickname)
		ps.setString(4, usr.password)
		ps.setString(5, usr.email)
		ps.setDate(6, usr.fechaDeNacimiento)
		ps.setString(7, usr.codigo)
		ps.execute()
		ps.close()
	}
	
	def armarDeclaracionInsert() {
		return "INSERT INTO Usuario " + "(" + this.camposDeUsuario + ") VALUES (?,?,?,?,?,?,?)"
	}
	
	//delete * from tabla where condicion
	override def void borrar(Usuario usr) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override def Usuario traer(Usuario usr, String field, String value) {

		var usuario = new Usuario()		
		val rs = this.armarResultadoDeBusqueda(field, value)
		this.armarUsuario(usuario, rs)
		return usuario
	}
	
	def armarUsuario(Usuario usuario, ResultSet set) {
		usuario.nombre = set.getString("nombre")
		usuario.apellido = set.getString("apellido")
		usuario.nickname = set.getString("nickname")
		usuario.password = set.getString("password")
		usuario.email = set.getString("email")
		usuario.fechaDeNacimiento = set.getDate("fechaDeNacimiento")
		usuario.codigo = set.getString("codigo")
	}
	
	//select campos from tabla where condiciones
	override def boolean contiene(Usuario usr, String field, String value) {

		var contiene = false
		val rs = this.armarResultadoDeBusqueda(field, value)
		while(rs.next()){
			contiene = rs.getString(field).equals(value)
		}
		return contiene
	}
	
	def armarResultadoDeBusqueda(String field, String value) {
		val declaracion = this.armarDeclaracionSelect(field, value)
		val ps = connection.prepareStatement(declaracion)
		ps.setString(1, value)
		val rs = ps.executeQuery()
		ps.close()
		return rs
	}
	
	def armarDeclaracionSelect(String field, String value) {
		var campos = this.camposDeUsuario()
		var declaracion = 'SELECT '+ campos + 'FROM Usuario WHERE ' + field + ' = ?'
		return declaracion
	}
	
	def camposDeUsuario() {
		return 'NOMBRE,' + 'APELLIDO,' + 'NICKNAME,' + 'PASSWORD' + 'EMAIL,' + 'FECHADENACIMIENTO,' + 'CODIGO'
	}
	
	//ver como arreglarlo
	override def void actualizar(Usuario usr, String field, String unique){
	//update tabla set campo=valor where condicion
		
	}
	
	override objectNotFoundError(Usuario usr) throws Exception {
		new usuarioNoEstaEnElServicioException(usr)
	}
	
	def getConnection() {
		Class.forName("com.mysql.jdbc.Driver");
		return DriverManager.getConnection("jdbc:mysql://localhost:8889/Epers_Ej1?user=root&password=root")
	}
	
	def void excecute(Function1<Connection, Object> closure){
		var Connection conn = null
		try{
			conn = this.connection
			closure.apply(conn)
		}finally{
			if(conn != null)
				conn.close();
		}
	}
	
}
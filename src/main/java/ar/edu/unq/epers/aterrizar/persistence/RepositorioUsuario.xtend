package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.domain.ArmadorDeDeclaraciones
import ar.edu.unq.epers.aterrizar.domain.Usuario
import ar.edu.unq.epers.aterrizar.domain.exceptions.usuarioNoEstaEnElServicioException
import java.sql.Connection
import java.sql.DriverManager
import java.sql.ResultSet
import java.util.ArrayList

class RepositorioUsuario implements Repositorio<Usuario>{
	
	Connection connection = this.getConnection()
	ArmadorDeDeclaraciones armador = new ArmadorDeDeclaraciones()
	
	//insert into tabla values (valores)
	override def void persistir(Usuario usr) {
		
		var declaracion = armador.armarDeclaracionInsert('Usuario', this.camposDeUsuario())
		val ps = this.setearValores(usr, declaracion)
		ps.execute()
		ps.close()
	}
	
	//delete * from tabla where condicion
	//en este metodo estoy decidiendo ya que hay una unica manera de encontrar a un usuario en la bd
	override def void borrar(Usuario usr) {
		
		var declaracion = armador.armarDeclaracionDelete('Usuario', 'NICKNAME', usr.nickname)
		var ps = connection.prepareStatement(declaracion)
		ps.setString(1, usr.nickname)
		ps.executeQuery()
		ps.close()
	}
	
	//select campos from tabla where condiciones	
	override def Usuario traer(Usuario usr, String field, String value) {

		val rs = this.armarResultadoDeBusqueda(field, value)
		return this.armarUsuario(rs)
	}

	//update tabla set campo=valor where condicion
	override def void actualizar(Usuario usr, String field, String unique){
		
		var declaracion = armador.armarDeclaracionUpdate('Usuario', this.camposDeUsuario(), this.valoresDeUsuario(usr), field, unique)
		val ps = this.setearValores(usr, declaracion)
		ps.setString(this.camposDeUsuario().length()+1, unique)
		ps.execute()
		ps.close()
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
	
	
	/*
	 * devuelve un usuario con los atributos cargados del resultset. Ya que nickname es unico este solo tiene un usuario
	 */
	def armarUsuario(ResultSet set) {
		val usuario = new Usuario()
		usuario.nombre = set.getString("nombre")
		usuario.apellido = set.getString("apellido")
		usuario.nickname = set.getString("nickname")
		usuario.password = set.getString("password")
		usuario.email = set.getString("email")
		usuario.fechaDeNacimiento = set.getDate("fechaDeNacimiento")
		usuario.codigo = set.getString("codigo")
		return usuario
	}
	
	/*
	 * devuelve un ResultSet con las tablas que cumplan la condicion de field=value
	 */
	def armarResultadoDeBusqueda(String field, String value) {
		val declaracion = armador.armarDeclaracionSelect('Usuario', this.camposDeUsuario(),field, value)
		val ps = connection.prepareStatement(declaracion)
		ps.setString(1, value)
		val rs = ps.executeQuery()
		ps.close()
		return rs
	}
	
	/*son los campos que voy a persistir en la base de datos
	 */
	def camposDeUsuario() {
		var campos = new ArrayList<String>()
		campos.add('NOMBRE')
		campos.add('APELLIDO')
		campos.add('NICKNAME')
		campos.add('PASSWORD')
		campos.add('EMAIL')
		campos.add('FECHADENACIMIENTO')
		campos.add('CODIGO')
		return campos
	}
	/*
	 * 
	 */
	def valoresDeUsuario(Usuario usr){
		var valores = new ArrayList<String>()
		valores.add(usr.nombre)
		valores.add(usr.apellido)
		valores.add(usr.nickname)
		valores.add(usr.password)
		valores.add(usr.email)
		valores.add(usr.fechaDeNacimiento.toString())
		valores.add(usr.codigo)
		return valores
	}
	

	/*
	 * setea los valores de un usuario para preparar la declaracion
	 */
	def setearValores(Usuario usr, String declaracion) {
		val ps = connection.prepareStatement(declaracion)
		ps.setString(1, usr.nombre)
		ps.setString(2, usr.apellido)
		ps.setString(3, usr.nickname)
		ps.setString(4, usr.password)
		ps.setString(5, usr.email)
		ps.setDate(6, usr.fechaDeNacimiento)
		ps.setString(7, usr.codigo)
		return ps
	}
	
	override objectNotFoundError(Usuario usr) throws Exception {
		new usuarioNoEstaEnElServicioException(usr)
	}
	//jdbc:mysql://<host>:<port>/<database_name> 
	def getConnection() {
		Class.forName("com.mysql.jdbc.Driver");
		var url = "jdbc:mysql://localhost:3306/aterrizar"
		var user = 'root'
		var password = 'jstrike1234'
		return DriverManager.getConnection(url, user, password)
	}
	
}
package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.domain.Usuario
import java.sql.Connection
import java.sql.DriverManager
import java.sql.ResultSet
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.domain.exceptions.UsuarioNoEstaEnElServicioException
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.domain.ArmadorDeDeclaraciones

@Accessors
class RepositorioUsuario implements Repositorio<Usuario>{
	
	Connection connection 
	ArmadorDeDeclaraciones armador
	
	new(){
		armador = new ArmadorDeDeclaraciones()
	}
	
	
	//insert into tabla values (valores)
	override def void persistir(Usuario usr) {
		
		var declaracion = armador.armarDeclaracionInsert('Usuario', this.camposDeUsuario())
		var ps = this.setearValoresYPrepararDeclaracion(usr, declaracion)
		ps.executeUpdate()
		ps.close()
	}
	
	//delete * from tabla where condicion
	//en este metodo estoy decidiendo ya que hay una unica manera de encontrar a un usuario en la bd
	override def void borrar(String campo, String valor) {
		
		var declaracion = armador.armarDeclaracionDelete('Usuario', campo)
		var ps = connection.prepareStatement(declaracion)
		ps.setString(1, valor)
		ps.executeUpdate()
		ps.close()
	}
	
	//select campos from tabla where condiciones	
	override def Usuario traer(String field, String value) {

		val ps = this.armarResultadoDeBusqueda(field, value)
		val rs = ps.executeQuery()
		ps.close()
		return this.armarUsuario(rs)
	}

	//update tabla set campo=valor where condicion
	override def void actualizar(Usuario usr, String field, String unique){
		
		var declaracion = armador.armarDeclaracionUpdate('Usuario', this.camposDeUsuario(), this.valoresDeUsuario(usr), field, unique)
		val ps = this.setearValoresYPrepararDeclaracion(usr, declaracion)
		var indicedecampocondicion = this.camposDeUsuario().length()+1 
		ps.setString(indicedecampocondicion, unique)
		ps.executeUpdate()
		ps.close()
	}
	//select campos from tabla where condiciones
	override def boolean contiene(String field, String value) {

		var contiene = false
		val ps = this.armarResultadoDeBusqueda(field, value)
		val rs = ps.executeQuery()

		while(rs.next()){
			contiene = rs.getString(field).equals(value)
		}
		ps.close()
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
		usuario.id = set.getInt("id")
		return usuario
	}
	
	/*
	 * devuelve un ResultSet con las tablas que cumplan la condicion de field=value
	 */
	def armarResultadoDeBusqueda(String field, String value) {
		var declaracion = armador.armarDeclaracionSelect('Usuario', this.camposDeUsuario(),field, value)
		var ps = connection.prepareStatement(declaracion)
		ps.setString(1, value)
		return ps
	}
	
	/*son los campos que voy a persistir en la base de datos
	 */
	def camposDeUsuario() {
		var campos = new ArrayList<String>()
		campos.add('nombre')
		campos.add('apellido')
		campos.add('nickname')
		campos.add('password')
		campos.add('email')
		campos.add('fechaDeNacimiento')
		campos.add('codigo')
		campos.add('id')
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
		valores.add(usr.id.toString())
		return valores
	}
	

	/*
	 * setea los valores de un usuario para preparar la declaracion
	 */
	def setearValoresYPrepararDeclaracion(Usuario usr, String declaracion) {
		var ps = connection.prepareStatement(declaracion)
		ps.setString(1, usr.nombre)
		ps.setString(2, usr.apellido)
		ps.setString(3, usr.nickname)
		ps.setString(4, usr.password)
		ps.setString(5, usr.email)
		ps.setDate(6, usr.fechaDeNacimiento)
		ps.setString(7, usr.codigo)
		ps.setInt(8, usr.id)
		return ps
	}
	
	override objectNotFoundError() throws Exception {
		throw new UsuarioNoEstaEnElServicioException()
	}
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
	def conectarAMiDB(){
		var url = "jdbc:mysql://localhost:3306/aterrizar"
		var user = 'root'
		var password = 'jstrike1234'
		connection = this.getConnection(url, user, password)		
	}
	
}
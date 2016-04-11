package ar.edu.unq.epers.aterrizar.persistence

import ar.edu.unq.epers.aterrizar.domain.Usuario
import java.sql.ResultSet
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.exceptions.UsuarioNoEstaEnElServicioException
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.utils.ArmadorDeDeclaraciones

@Accessors
class RepositorioUsuario extends Repositorio<Usuario>{
	 
	ArmadorDeDeclaraciones armador
	
	new(){
		armador = new ArmadorDeDeclaraciones()
	}
	
	//insert into tabla values (valores)
	override def void persistir(Usuario usr) {
		//creo los campos y le saco el campo autoincrementable
		var camposSinAutoIncrementable = this.campos()
		camposSinAutoIncrementable.remove('id')
		
		var declaracion = armador.armarDeclaracionInsert('Usuario', camposSinAutoIncrementable)
		var ps = this.setearValoresYPrepararDeclaracionSinCampoAutoIncrementable(usr, declaracion,1)
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
	override def Usuario traer(String field, String value){

		var ps = this.armarResultadoDeBusqueda(field, value)
		var rs = ps.executeQuery()
		rs.next()
		var usuario = this.armarObjeto(rs)
		ps.close()
		return usuario
	}

	//update tabla set campo=valor where condicion
	override def void actualizar(Usuario usr, String field, String unique){
		
		var declaracion = armador.armarDeclaracionUpdate('Usuario', this.campos(), this.valores(usr), field)
		val ps = this.setearValoresYPrepararDeclaracionSinCampoAutoIncrementable(usr, declaracion,2)
		ps.setInt(1, usr.id)
		var indicedecampocondicion = this.campos().length()+1
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
			contiene = contiene || rs.getString(field).equals(value)
		}
		ps.close()
		return contiene
	}	
	
	/*
	 * devuelve un usuario con los atributos cargados del resultset. Ya que nickname es unico este solo tiene un usuario
	 */
	def armarObjeto(ResultSet set) {
		var usuario = new Usuario()
		usuario.id = set.getInt("id")
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
		var declaracion = armador.armarDeclaracionSelect('Usuario', this.campos(),field)
		var ps = connection.prepareStatement(declaracion)
		ps.setString(1, value)
		return ps
	}
	
	/*
	 * son los campos que voy a persistir en la base de datos
	 */
	override def campos() {
		var campos = new ArrayList<String>()
		campos.add('id')
		campos.add('nombre')
		campos.add('apellido')
		campos.add('nickname')
		campos.add('password')
		campos.add('email')
		campos.add('fechaDeNacimiento')
		campos.add('codigo')
		return campos
	}
	/*
	 * son los valores de un usuario
	 */
	override def valores(Usuario usr){
		var valores = new ArrayList<String>()
		valores.add(usr.id.toString())
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
	 * esta solucion es horrible pero no se me ocurrio otra forma de manejar campos sin poder elegir uno como 
	 * no usable sino q es la base de datos la que se encarga de setearlo
	 */
	def setearValoresYPrepararDeclaracionSinCampoAutoIncrementable(Usuario usr, String declaracion, int startIndex) {
		var ps = connection.prepareStatement(declaracion)
		ps.setString(startIndex, usr.nombre)
		ps.setString(startIndex+1, usr.apellido)
		ps.setString(startIndex+2, usr.nickname)
		ps.setString(startIndex+3, usr.password)
		ps.setString(startIndex+4, usr.email)
		ps.setDate(startIndex+5, usr.fechaDeNacimiento)
		ps.setString(startIndex+6, usr.codigo)
		return ps
	}
	
	override objectNotFoundError() throws Exception {
		throw new UsuarioNoEstaEnElServicioException()
	}
	
	def conectarAMiDB(){
		var url = "jdbc:mysql://localhost:3306/aterrizar"
		var user = 'root'
		var password = 'jstrike1234'
		connection = this.getConnection(url, user, password)		
	}
	
}
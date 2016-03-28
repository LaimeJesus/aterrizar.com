package ar.edu.unq.epers.aterrizar.domain

import java.util.List
/*
 * este objecto fue creado para realizar armar los mensajes sql que se necesitan para comunicarse con la base de datos mysql, pero solo
 * sirve para declaraciones preparadas, es decir preparedStatements
 */
class ArmadorDeDeclaraciones {
	
	/*
	 * devuelve un string que utiliza la sintaxis de sql para la declaracion INSERT. 
	 */
	def armarDeclaracionInsert(String tabla, List<String> campos) {
		var fields = ''
		for(campo : campos){
			fields = fields + '?,'
		}
		fields = fields.substring(0, fields.length()-1)
		fields = '(' + fields + ')'
		var strCampos = this.separar(campos, ',')
		var declaracion = 'INSERT INTO ' + tabla + ' (' + strCampos + ') VALUES' + fields 
		return declaracion
	}
	
	/*
	 * devuelve un string que utiliza la sintaxis de sql para una declaracion SELECT
	 */
	 
	def armarDeclaracionSelect(String tabla, List<String> campos, String field) {
		return 'SELECT '+ this.separar(campos, ',') + ' FROM ' + tabla + ' WHERE ' + field + ' = ?'
	}

	/*
	 * devuelve un string que utiliza la sintaxis de sql para una declaracion UPDATE
	 */

	def armarDeclaracionUpdate(String tabla, List<String> campos, List<String> valores, String field) {
		return 'UPDATE ' + tabla + ' SET ' + this.separar(campos, '=?,') + ' WHERE ' + field + ' = ?'	
	}
	/*
	 * devuelve un string que utiliza la sintaxis de sql para una declaracion DELETE
	 */
	
	def armarDeclaracionDelete(String tabla, String campo){
		return 'DELETE FROM ' + tabla + ' WHERE ' + campo + ' = ?'
	}
	
	def armarDeclaracionDrop(String tabla, String campo, String valor){
		return 'DROP' + tabla + 'WHERE' + campo + ' = ' + valor
	}
	
	def separar(List<String> campos, String separador) {
		var res = ''
		for(campo : campos){
			res = res + campo + separador
		}
		var size = res.length()-1
		res = res.substring(0, size)
		return res
	}

}
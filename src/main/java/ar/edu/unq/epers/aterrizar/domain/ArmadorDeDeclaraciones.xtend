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
		fields = this.separar(campos, '?,')
		fields = '(' + fields + ')'
		
		return 'INSERT INTO ' + tabla + ' (' + this.separar(campos, ',') + ') VALUES' + fields
	}
	
	/*
	 * devuelve un string que utiliza la sintaxis de sql para una declaracion SELECT
	 */
	 
	def armarDeclaracionSelect(String tabla, List<String> campos, String field, String value) {
		return 'SELECT '+ this.separar(campos, ',') + ' FROM ' + tabla + ' WHERE ' + field + ' = ?'
	}

	/*
	 * devuelve un string que utiliza la sintaxis de sql para una declaracion UPDATE
	 */

	def armarDeclaracionUpdate(String tabla, List<String> campos, List<String> valores, String field, String unique) {
	return 'UPDATE ' + tabla + ' SET ' + this.separar(campos, '=?,') + 'WHERE ' + field + ' = ?'	
	}
	/*
	 * devuelve un string que utiliza la sintaxis de sql para una declaracion DELETE
	 */
	
	def armarDeclaracionDelete(String tabla, String campo, String valor) {
		return 'DELETE FROM ' + tabla + 'WHERE ' + campo + ' = ?'
	}
	
	def separar(List<String> campos, String separador) {
		var res = ''
		for(campo : campos){
			res = campo + separador
		}
		res = res.substring(0, res.length()-1)
		return res
	}

}
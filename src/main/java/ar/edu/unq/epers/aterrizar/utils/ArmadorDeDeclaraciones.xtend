package ar.edu.unq.epers.aterrizar.utils

import java.util.List
import java.util.ArrayList

/*
 * este objecto fue creado para armar los mensajes sql que se necesitan para comunicarse con la base de datos mysql, pero solo
 * sirve para declaraciones preparadas, es decir preparedStatements
 */
class ArmadorDeDeclaraciones {


	def createTable(String table, List<String> campos){
		var query = "CREATE TABLE " + table + " (" + separar(campos, ",") + ";"
		query
	}
	
	/*
	 * devuelve un string que utiliza la sintaxis de SQL para la declaracion INSERT. 
	 */
	def armarDeclaracionInsert(String tabla, List<String> campos) {

		var strCampos = armarCampos(campos)
		var fields = armarValuesParametrizado(campos)
		var declaracion = insert(tabla, strCampos, fields)
		return declaracion
	}

	def armarInsert(String tabla, List<String> campos, List<String> values) {
		var resCampos = armarCampos(campos)
		var resValues = armarCampos(values)
		var res = insert(tabla, resCampos, resValues)
		res
	}

	/*
	 * devuelve un string que utiliza la sintaxis de sql para una declaracion DELETE
	 */
	def armarDeclaracionDelete(String tabla, String campo) {
		delete(tabla, campo, '?')
	}

	def armarDelete(String tabla, String campo, String value) {
		delete(tabla, campo, value)
	}

	/*
	 * devuelve un string que utiliza la sintaxis SQL para una declaracion SELECT
	 */
	def armarDeclaracionSelect(String tabla, List<String> campos, String field) {
		select(this.separar(campos, ','), tabla, field, '?')
	}

	def armarSelect(String tabla, List<String> campos, String field, String value) {
		select(this.separar(campos, ','), tabla, field, value)
	}

	def armarSelect(String tabla, String field, String value) {
		select('*', tabla, field, value)
	}

	/*
	 * devuelve un string que utiliza la sintaxis de sql para una declaracion UPDATE
	 */
	def armarDeclaracionUpdate(String tabla, List<String> campos, List<String> valores, String field) {
		var resCampos = separar(campos, '=?,')
		update(tabla, resCampos, field, '?')
	}

	/*
	 * precondicion campos.length == values.length
	 */
	def armarUpdate(String tabla, List<String> campos, List<String> values, String field, String value) {
		var res = zip(campos, values)
		var newRes = separar(res, ',')
		update(tabla, newRes, field, value)
	}

	def zipWith(List<String> campos, List<String> values, String sep){
		var res = new ArrayList<String>
		for (var i = 0; i < campos.length; i++) {
			var c = campos.get(i)
			var v = values.get(i)
			var concat = c.concat(sep).concat(v)
			res.add(concat)
		}
		res
	}

	def zip(List<String> campos, List<String> values) {
		zipWith(campos, values, '=')
	}

	///////////////////////////////////////////////
	//metodos privados
	///////////////////////////////////////////////
	def insert(String tabla, String campos, String values) {
		return 'INSERT INTO ' + tabla + ' ' + campos + ' VALUES ' + values
	}

	def select(String campos, String tabla, String field, String value) {
		'SELECT ' + campos + ' FROM ' + tabla + ' WHERE ' + field + ' = ' + value
	}

	def delete(String tabla, String campo, String value) {
		'DELETE FROM ' + tabla + ' WHERE ' + campo + ' = ' + value
	}

	def update(String tabla, String campos, String field, String value) {
		'UPDATE ' + tabla + ' SET ' + campos + ' WHERE ' + field + ' = ' + value
	}

	/*
	 * devuelve un string que utiliza la sintaxis de sql para una declaracion DROP
	 */
	def armarDeclaracionDrop(String tabla, String campo, String valor) {
		return 'DROP' + tabla + 'WHERE' + campo + ' = ' + valor
	}

	/*
	 * @return: devuelve un string resultado de haber separado cada campo en campos por separador
	 */
	def separar(List<String> campos, String separador) {
		var res = ''
		for (campo : campos) {
			res = res + campo + separador
		}
		var sizeDelNuevoStringMenosUno = res.length() - 1
		res = res.substring(0, sizeDelNuevoStringMenosUno)
		return res
	}

	def armarValuesParametrizado(List<String> campos) {

		//var res = separar(campos.map['?,'], '')
		var fields = ''
		for (campo : campos) {
			fields = fields + '?,'
		}
		fields = fields.substring(0, fields.length() - 1)
		fields
	}

	//separa una lista de strings entre comas y encierra entre parentensis el string final
	def armarCampos(List<String> campos) {
		var res = separar(campos, ',')
		res = '(' + res + ')'
		res
	}
}

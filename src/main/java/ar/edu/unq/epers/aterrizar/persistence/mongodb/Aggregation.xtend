package ar.edu.unq.epers.aterrizar.persistence.mongodb;

import com.mongodb.BasicDBObject
import com.mongodb.DBObject
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.xtext.xbase.lib.Functions.Function1

class Aggregation<T> {
	var Filter<T> matchFilter
	var Filter<T> projection
	var Home<T> home
	
	new(Home<T> home){
		this.home = home
	}

	def match() {
		matchFilter = new Filter<T>(this)
		matchFilter.add("$match")
	}
	
	def match(String property, Object value) {
		match.add(property, value)
	}

	def project() {
		projection = new Filter<T>(this)
		projection.add("$project")
	}

	def build() {
		val t = #[matchFilter.build(), projection.build()]
		println(t)
		t
	}
	
	def List<T> execute(){
		home.find(this)
	}
	
}

class Filter<T> {
	var Aggregation<T> aggregation
	var Map<String, Object> mapping = new HashMap

	new(Aggregation<T> aggregation) {
		this.aggregation = aggregation
	}

	def add(String property, Object value) {
		mapping.put(property, value)
		aggregation
	}
	
	def rtn(String property) {
		add(property, 1)
		this
	}

	def add(String property) {
		val newValue = new Filter(aggregation)
		add(property, newValue)
		newValue
	}

	def filter(String collection) {
		val filter = add(collection).add("$filter")
		filter.add("input", '$' + collection)
		filter.add("as", "alias")
		filter.add("cond")
	}

	def eq(String property, Object value) {
		add("$eq", #["$$alias." + property, value])
		this
	}
	
	def and(List<Function1<Filter<T>, Filter<T>>> criterias) {
		add("$and", criterias.map[ it.apply(new Filter<T>(aggregation))])
		aggregation
	}
	
	def or(List<Function1<Filter<T>, Filter<T>>> criterias) {
		add("$or", criterias.map[ it.apply(new Filter<T>(aggregation)).build])
		aggregation
	}

	def DBObject build() {
		val map = new HashMap()
		mapping.forEach [ key, value |
			switch value {
				Filter<T> : map.put(key, value.build)
				default: map.put(key, value)  
			}
		]
		new BasicDBObject(map)
	}
	
	override toString() {
		build().toString
	}
	
}

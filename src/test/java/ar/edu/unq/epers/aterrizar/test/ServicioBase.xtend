package ar.edu.unq.epers.aterrizar.test

import ar.edu.unq.epers.aterrizar.servicios.ServicioRegistroUsuarioConHibernate

class ServicioBase {
	
	ServicioRegistroUsuarioConHibernate servicioUsuarios
	
	def void setUp(){
		servicioUsuarios = new ServicioRegistroUsuarioConHibernate
		
		
	}
}
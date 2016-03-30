package ar.edu.unq.epers.aterrizar.domain

import org.junit.Test
import org.junit.Before
import ar.edu.unq.epers.aterrizar.persistence.RepositorioUsuario

import static org.junit.Assert.*;

import java.util.ArrayList;

//import static org.mockito.Mockito.*;

class RecorderServiceTest {
	
	Usuario mockUser1 
	
	// opcion 1
	RepositorioUsuario mockRepo
	CreadorDeCodigosBarato mockCodigo // RecorderService
	EnviadorDeMails cartero
	
	// opcion 2
	RecorderService servicio
	
	Mail mail
	
	ArrayList<Mail> mails
	
	@Before
	def setUp(){
		
	this.mails.add(mail)
	
	// this.user1 = new Usuario("beto", "gonzales", "pepo","12345", mails)
	// no seria necesario tener un constructor???
	
	this.mockUser1 = mock(Usuario.class) // como deberia importar el mock?
	
	// opcion 1
	this.mockRepo = mock(RepositorioUsuario.class)
	this. mockCodigo = mock(CreadorDeCodigosBarato.class)
	this.cartero = mock(EnviadorDeMails.class)
	
	// opcion 2
	this.servicio = new
	
	}
	
	@Test
	def testConstructor(){
				
		
	}
	
	
	
}
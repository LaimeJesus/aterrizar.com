package ar.edu.unq.epers.aterrizar.test

import ar.edu.unq.epers.aterrizar.domain.Usuario
import java.sql.Date
import ar.edu.unq.epers.aterrizar.domain.RecorderService
import ar.edu.unq.epers.aterrizar.persistence.RepositorioUsuario
import org.mockito.Mockito
import ar.edu.unq.epers.aterrizar.domain.CreadorDeCodigos
import ar.edu.unq.epers.aterrizar.domain.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.domain.CreadorDeMails
import ar.edu.unq.epers.aterrizar.domain.Mail
import ar.edu.unq.epers.aterrizar.domain.exceptions.RegistrationException
import org.junit.Before
import org.junit.Test
import org.junit.Assert

class RecorderServiceTest{
	
	RecorderService sudo
	Usuario user
	RepositorioUsuario repoUserMock
	CreadorDeCodigos creadorDeCodigosMock
	EnviadorDeMails enviadorDeMailsMock
	CreadorDeMails creadorDeMailsMock
	
	@Before
	def setUp(){
		val user = new Usuario()
		user.nombre = 'pepe'
		user.apellido = 'garcia'
		user.nickname = 'elmaspiola'
		user.password = 'facil'
		user.email = ''
		user.fechaDeNacimiento = Date.valueOf('1994-12-21')

		val sudo = new RecorderService()
		repoUserMock = Mockito.mock(RepositorioUsuario)
		creadorDeCodigosMock = Mockito.mock(CreadorDeCodigos)
		enviadorDeMailsMock = Mockito.mock(EnviadorDeMails)
		creadorDeMailsMock = Mockito.mock(CreadorDeMails)
		
		sudo.repositorio = repoUserMock 
		sudo.creadorDeCodigos = creadorDeCodigosMock
		sudo.enviadorDeMails = enviadorDeMailsMock
		sudo.creadorDeMails = creadorDeMailsMock

	}
	
	@Test
	def testRegistrarUsuarioQueNoExisteEnElSistema(){

		var codigoFromMock = 'nousado'
		var mailFromMock = new Mail()

		Mockito.when(creadorDeCodigosMock.crearCodigo()).thenReturn(codigoFromMock)
		Mockito.when(creadorDeMailsMock.crearMailParaUsuario('registrador', user, codigoFromMock)).thenReturn(mailFromMock)
		Mockito.when(repoUserMock.contiene(user, 'nickname', user.nickname)).thenReturn(false)
		
		var ultimoId = sudo.ids		
		sudo.registrarUsuario(user)
		var userId = user.id
		
		Assert.assertEquals(ultimoId, userId)
		
		Mockito.verify(repoUserMock).persistir(user)
		Mockito.verify(repoUserMock).contiene(user, 'nickname', user.nickname)
		Mockito.verify(creadorDeCodigosMock).crearCodigo()
		Mockito.verify(enviadorDeMailsMock).enviarMail(mailFromMock)
	}
	
	@Test
	def testRegistrarUsuarioQueYaExisteEnElSistema() throws Exception{
		Mockito.when(repoUserMock.contiene(user, 'nickname', user.nickname)).thenReturn(true)
		try{
			sudo.registrarUsuario(user)
			//fail("registrar no funciona correctamente")
			}	
		catch(RegistrationException expected){
			
		Assert.assertEquals(sudo.ids, 0)
		Mockito.verify(repoUserMock).persistir(user)
		Mockito.verify(repoUserMock).contiene(user, 'nickname', user.nickname)
		}				
	}
}
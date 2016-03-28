package ar.edu.unq.epers.aterrizar.test

import ar.edu.unq.epers.aterrizar.domain.Mail
import ar.edu.unq.epers.aterrizar.domain.exceptions.RegistrationException
import org.junit.Test

import static org.junit.Assert.*
import org.mockito.Mockito
import org.junit.Before
import ar.edu.unq.epers.aterrizar.domain.Usuario
import java.sql.Date
import ar.edu.unq.epers.aterrizar.domain.RecorderService
import ar.edu.unq.epers.aterrizar.persistence.RepositorioUsuario
import ar.edu.unq.epers.aterrizar.domain.CreadorDeCodigos
import ar.edu.unq.epers.aterrizar.domain.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.domain.CreadorDeMails
import ar.edu.unq.epers.aterrizar.domain.exceptions.MyValidateException
import ar.edu.unq.epers.aterrizar.domain.exceptions.UsuarioNoEstaEnElServicioException
import ar.edu.unq.epers.aterrizar.domain.exceptions.MyLoginException
import ar.edu.unq.epers.aterrizar.domain.exceptions.ChangingPasswordException

class RecorderServiceTest{
	
	RepositorioUsuario repoUserMock
	
	CreadorDeCodigos creadorDeCodigosMock
	
	EnviadorDeMails enviadorDeMailsMock
	
	CreadorDeMails creadorDeMailsMock
	
	Usuario usuario
	
	RecorderService sudo
	
	@Before
	def void setUp(){
		val usuario = new Usuario()
		usuario.nombre = 'pepe'
		usuario.apellido = 'garcia'
		usuario.nickname = 'pepillo'
		usuario.password = '1234'
		usuario.email = 'mi@gmail.com'
		usuario.fechaDeNacimiento = Date.valueOf('1994-12-21')
		usuario.codigo = '1234'
		
		val sudo = new RecorderService()
		repoUserMock = Mockito.mock(RepositorioUsuario)
		creadorDeCodigosMock = Mockito.mock(CreadorDeCodigos)
		enviadorDeMailsMock = Mockito.mock(EnviadorDeMails)
		creadorDeMailsMock = Mockito.mock(CreadorDeMails)
		
		sudo.repositorio = repoUserMock 
		sudo.creadorDeCodigos = creadorDeCodigosMock
		sudo.enviadorDeMails = enviadorDeMailsMock
		sudo.creadorDeMails = creadorDeMailsMock

		Mockito.when(repoUserMock.contiene('nickname', usuario.nickname)).thenReturn(true)
		Mockito.when(repoUserMock.traer('nickname', usuario.nickname)).thenReturn(usuario)
	}
	
	@Test 
	def void testRegistrarUsuarioQueNoExisteEnElSistema(){


		var codigoFromMock = 'nousado'
		var mailFromMock = new Mail()

		Mockito.when(creadorDeCodigosMock.crearCodigo()).thenReturn(codigoFromMock)
		Mockito.when(creadorDeMailsMock.crearMailParaUsuario('registrador', usuario, codigoFromMock)).thenReturn(mailFromMock)
		Mockito.when(repoUserMock.contiene('nickname', usuario.nickname)).thenReturn(false)
		
		var ultimoId = sudo.ids		
		sudo.registrarUsuario(usuario)
		var userId = usuario.id
		
		assertEquals(ultimoId, userId)
		
		Mockito.verify(repoUserMock).persistir(usuario)
		Mockito.verify(repoUserMock).contiene('nickname', usuario.nickname)
		Mockito.verify(creadorDeCodigosMock).crearCodigo()
		Mockito.verify(enviadorDeMailsMock).enviarMail(mailFromMock)
	}
	
	@Test
	def void testRegistrarUsuarioQueYaExisteEnElSistema() throws Exception{
		try{
			sudo.registrarUsuario(usuario)
			fail("registrar no funciona correctamente")
			}	
		catch(RegistrationException expected){
			
		assertEquals(sudo.ids, 0)
		Mockito.verify(repoUserMock).persistir(usuario)
		Mockito.verify(repoUserMock).contiene('nickname', usuario.nickname)
		}				
	}
	
	@Test 
	def void testValidarUsuarioQueAunNoValidoSuCodigoCambiaSuCodigoAUsado(){

		usuario.codigo = 'nousado'
		var codenousado = 'nousado'
		
		sudo.validar(usuario,codenousado)
		
		
		assertEquals(usuario.codigo, 'usado')
		Mockito.verify(repoUserMock).actualizar(usuario, 'nickname', usuario.nickname)
		Mockito.verify(repoUserMock).traer('nickname', usuario.nickname)
		
	}
	
	@Test
	def void testValidarUsuarioQueIngresaMalSuCodigoArrojaUnaExepcion(){

		try{
			sudo.validar(usuario, '2345')
			fail("validar no funciona bien")
			}
		catch(MyValidateException expected){
			
			assertEquals(usuario.codigo, '1234')
			Mockito.verify(repoUserMock).traer('nickname', usuario.nickname)
			Mockito.verify(repoUserMock, Mockito.never()).actualizar(usuario, 'nickname', usuario.nickname)
			
		}	
	}
	
	//esto creo que en realidad deberia testear el metodo traerUsuario del recorderService
	@Test
	def void testLogearUnUsuarioQueNoExisteEnElSistemaArrojaUnaExcepcion(){
		
		var pw = 'doesnt care'
		var nickname = 'pichu'
		
		Mockito.when(repoUserMock.contiene('nickname', nickname)).thenReturn(false)
		
		try{
			sudo.login(nickname, pw)
			fail("traer no funciona")
		}
		catch(UsuarioNoEstaEnElServicioException expected){
			Mockito.verify(repoUserMock).contiene('nickname', nickname)
			Mockito.verify(repoUserMock).objectNotFoundError()
		}
	}
	
	@Test
	def void testLogearUnUsuarioConContrasenhaIncorrectaArrojaUnaExcepcion(){
		
		var errorPw = 'erronea'
		try{
			sudo.login(usuario.nickname, errorPw)
			fail("logear no funciona")
		}
		catch(MyLoginException expected){
			Mockito.verify(repoUserMock).contiene('nickname', usuario.nickname)
			Mockito.verify(repoUserMock).traer('nickname', usuario.nickname)
			assertFalse(usuario.password.equals(errorPw))
		}
		
	}
	
	@Test
	def void testCambiarContrasenhaPorLaMismaContrasenhaArrojaUnaExcepcion(){
		var expectedPw = '1234'
		try{
			sudo.changePassword(usuario, expectedPw)
			fail("cambiar contrasenha no funciona")
		}
		catch(ChangingPasswordException expected){
			assertEquals(usuario.password, expectedPw)
			Mockito.verify(repoUserMock).contiene('nickname', usuario.nickname)
			Mockito.verify(repoUserMock).traer('nickname', usuario.nickname)
		}
	}
	
	@Test
	def void testTraerUnUsuarioQueNoExisteEnElRepositorioArrojaUnaExcepcion(){
		Mockito.when(repoUserMock.contiene('nickname', usuario.nickname)).thenReturn(false)
		try{
			sudo.traerUsuarioDelRepositorio('nickname', usuario.nickname)
		}
		catch(UsuarioNoEstaEnElServicioException expected){
			Mockito.verify(repoUserMock).objectNotFoundError()
			Mockito.verify(repoUserMock).contiene('nickname', usuario.nickname)
		}
	}
	
}
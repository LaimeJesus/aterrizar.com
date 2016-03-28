package ar.edu.unq.epers.aterrizar.test

import ar.edu.unq.epers.aterrizar.domain.Mail
import org.junit.Test

import static org.junit.Assert.*
import org.mockito.Mockito
import org.junit.Before
import ar.edu.unq.epers.aterrizar.domain.Usuario
import java.sql.Date
import ar.edu.unq.epers.aterrizar.domain.CreadorDeCodigos
import ar.edu.unq.epers.aterrizar.domain.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.domain.CreadorDeMails
import servicios.RecorderService
import org.junit.After
import ar.edu.unq.epers.aterrizar.domain.exceptions.RegistrationException
import ar.edu.unq.epers.aterrizar.domain.exceptions.MyValidateException
import ar.edu.unq.epers.aterrizar.domain.exceptions.UsuarioNoEstaEnElServicioException
import ar.edu.unq.epers.aterrizar.domain.exceptions.ChangingPasswordException

class RecorderServiceTest{
	
	CreadorDeCodigos creadorDeCodigosMock
	EnviadorDeMails enviadorDeMailsMock
	CreadorDeMails creadorDeMailsMock
	Usuario usuario
	RecorderService sudo
	String codigoFromMock
	Mail mailFromMock
	
	@Before
	def void setUp(){
		usuario = new Usuario=>[
			nombre = 'pepe'
			apellido = 'garcia'
			nickname = 'pepillo'
			password = '1234'
			email = 'mi@gmail.com'
			fechaDeNacimiento = Date.valueOf('1994-12-21')
			codigo = 'nousado'
		]
		
		
		sudo = new RecorderService()
		creadorDeCodigosMock = Mockito.mock(CreadorDeCodigos)
		enviadorDeMailsMock = Mockito.mock(EnviadorDeMails)
		creadorDeMailsMock = Mockito.mock(CreadorDeMails)
		
		sudo.creadorDeCodigos = creadorDeCodigosMock
		sudo.enviadorDeMails = enviadorDeMailsMock
		sudo.creadorDeMails = creadorDeMailsMock
		
		var url = "jdbc:mysql://localhost:3306/aterrizar"
		var user = 'root'
		var pass = 'jstrike1234'
		sudo.repositorio.conectarABDConMySql(url, user, pass)
		
		codigoFromMock = 'nousado'
		mailFromMock = new Mail()

		sudo.registrarUsuario(usuario)

		Mockito.when(creadorDeCodigosMock.crearCodigo()).thenReturn(codigoFromMock)
		Mockito.when(creadorDeMailsMock.crearMailParaUsuario('registrador', usuario, codigoFromMock)).thenReturn(mailFromMock)
		
	}
	
	@Test 
	def void testRegistrarUsuarioQueNoExisteEnElSistema(){

		var nickname = usuario.nickname

		var userId = usuario.id
		
		assertEquals(1, userId)
		assertTrue(sudo.repositorio.contiene('nickname', nickname))
	}
	
	@Test
	def void testRegistrarUsuarioQueYaExisteEnElSistemaArrojaUnaExcepcion() throws Exception{
		try{
			sudo.registrarUsuario(usuario)
			fail("registrar no funciona correctamente")
			}	
		catch(RegistrationException expected){
			
		assertTrue(sudo.repositorio.contiene('nickname', usuario.nickname))
		}				
	}

	@Test 
	def void testValidarUsuarioQueAunNoValidoSuCodigoCambiaSuCodigoAUsado(){

		var codenousado = usuario.codigo
		
		sudo.validar(usuario, codenousado)
		var user = sudo.repositorio.traer('nickname', usuario.nickname)
		
		assertTrue(user.estaValidado())
	}
		
	@Test
	def void testValidarUsuarioQueIngresaMalSuCodigoArrojaUnaExcepcion(){

		var pwerroneo = 'pwerroneo'
		try{
			sudo.validar(usuario, pwerroneo)
			fail("validar no funciona bien")
			}
		catch(MyValidateException expected){
			
			var userCode = sudo.repositorio.traer('nickname', usuario.nickname).codigo
			
			assertFalse(userCode.equals(pwerroneo))			
		}	
	}
	
	//esto creo que en realidad deberia testear el metodo traerUsuario del recorderService
	@Test
	def void testLogearUnUsuarioQueNoExisteEnElSistemaArrojaUnaExcepcion(){
		
		var pw = 'doesnt care'
		var nickname = 'pichu'
		
		try{
			sudo.login(nickname, pw)
			fail("traer no funciona")
		}
		catch(UsuarioNoEstaEnElServicioException expected){
			assertFalse(sudo.repositorio.contiene('nickname', nickname))
		}
	}
	
	
	@Test
	def void testCambiarContrasenhaPorLaMismaContrasenhaArrojaUnaExcepcion(){
		var actualPw = usuario.password
		var expectedPw = '1234'
		try{
			sudo.changePassword(usuario, expectedPw)
			fail("cambiar contrasenha no funciona")
		}
		catch(ChangingPasswordException expected){
			assertEquals(actualPw, expectedPw)
		}
	}
	
	@Test
	def void testCambiarContrasenhaPorOtraActualizaLaBaseDeDatos(){
		var nueva = 'dificil'
		sudo.changePassword(usuario, nueva)
		var newPassword = sudo.repositorio.traer('nickname', usuario.nickname).password 
		assertEquals(nueva, newPassword)
	}
	/*
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
	
	*/
	@After
	def void testBorrarUsuarioQueFueCreadoEnSetUp(){
		var nicknameUser1 = usuario.nickname
		sudo.repositorio.borrar('nickname', nicknameUser1)
		
	}
	
}
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
import org.junit.After
import ar.edu.unq.epers.aterrizar.domain.exceptions.RegistrationException
import ar.edu.unq.epers.aterrizar.domain.exceptions.MyValidateException
import ar.edu.unq.epers.aterrizar.domain.exceptions.UsuarioNoEstaEnElServicioException
import ar.edu.unq.epers.aterrizar.domain.exceptions.ChangingPasswordException
import ar.edu.unq.epers.aterrizar.domain.exceptions.MyLoginException
import ar.edu.unq.epers.aterrizar.servicios.RecorderService

class RecorderServiceTest{
	
	CreadorDeCodigos creadorDeCodigosMock
	EnviadorDeMails enviadorDeMailsMock
	CreadorDeMails creadorDeMailsMock
	Usuario usuario
	RecorderService sudo
	String codigoFromMock
	Mail mailFromMock
	
	/*
	 * Solo testeo los metodos que me parecieron mas importantes del servicio, los que no se testearon del servicio fueron
	 * porque estos se usan de soporte en los importantes.
	 */
	
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
		Mockito.when(creadorDeCodigosMock.crearCodigo()).thenReturn(codigoFromMock)
		Mockito.when(creadorDeMailsMock.crearMailParaUsuario('registrador', usuario, codigoFromMock)).thenReturn(mailFromMock)
		sudo.registrarUsuario(usuario)

		
	}
	
	@Test 
	def void testRegistrarUsuarioQueNoExisteEnElSistema(){

		var nickname = usuario.nickname

		var userId = usuario.id
		
		assertEquals(1, userId)
		assertTrue(sudo.repositorio.contiene('nickname', nickname))
		Mockito.verify(creadorDeCodigosMock).crearCodigo()
		Mockito.verify(creadorDeMailsMock).crearMailParaUsuario('registrador', usuario, codigoFromMock)
		Mockito.verify(enviadorDeMailsMock).enviarMail(mailFromMock)
	}
	
	@Test
	def void testRegistrarUsuarioQueYaExisteEnElSistemaArrojaUnaExcepcionDeRegistracion() throws Exception{
		try{
			sudo.registrarUsuario(usuario)
			fail("registrar no funciona correctamente")
			}	
		catch(RegistrationException expected){
			
		assertTrue(sudo.repositorio.contiene('nickname', usuario.nickname))
		
		//Esto significa que los objetos creadorDeCodigos y creadorDemails y enviadorDeMails solo fueron llamados una vez en el
		//setUp y no en este metodo
		Mockito.verify(creadorDeCodigosMock, Mockito.times(1)).crearCodigo()
		Mockito.verify(creadorDeMailsMock, Mockito.times(1)).crearMailParaUsuario('registrador', usuario, codigoFromMock)
		Mockito.verify(enviadorDeMailsMock, Mockito.times(1)).enviarMail(mailFromMock)
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
	def void testValidarUsuarioQueIngresaMalSuCodigoArrojaUnaExcepcionDeValidacion(){

		var codigoerroneo = 'codigoerroneo'
		try{
			sudo.validar(usuario, codigoerroneo)
			fail("validar no funciona bien")
			}
		catch(MyValidateException expected){
			
			var userCode = sudo.repositorio.traer('nickname', usuario.nickname).codigo
			
			assertFalse(userCode.equals(codigoerroneo))			
		}	
	}
	
	@Test
	def void testLogearUnUsuarioQueNoFueValidadoEnElSistemaArrojaUnaExcepcionDeLogeo(){
		try{
			sudo.login(usuario.nickname, usuario.password)
			fail('logear no funciona correctamente')
		}		
		catch(MyLoginException expected){
			var usuario = sudo.repositorio.traer('nickname', usuario.nickname)
			assertFalse(usuario.estaValidado)
		}
	}
	
	@Test
	def void testLogearUnUsuarioConContrasenhaIncorrectaArrojaUnaExcepcionDeLogeo(){
		var wrongPassword = 'wrong'
		try{
			sudo.login(usuario.nickname, wrongPassword)
			fail('login no funciona')
		}
		catch(MyLoginException expected){
			var actualPassword = sudo.repositorio.traer('nickname', usuario.nickname).password
			assertFalse(wrongPassword.equals(actualPassword))
		}
	}
	
	@Test
	def void testLogearUnUsuarioQueEstaValidadoEnElSistemaLoLogeaCorrectamente(){
		var nick = usuario.nickname
		sudo.validar(usuario, 'nousado')
		var usuarioFromRepo = sudo.login(nick, usuario.password)
		
		assertEquals(nick, usuarioFromRepo.nickname)
	}
	
	
	@Test
	def void testCambiarContrasenhaPorLaMismaContrasenhaArrojaUnaExcepcionDeCambiarContrasenha(){
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
	
	@Test
	def void testTraerUnUsuarioQueNoExisteEnElRepositorioArrojaUnaExcepcionDeUsuarioNoEncontrado(){
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
	
	@After
	def void testBorrarUsuarioQueFueCreadoEnSetUp(){
		var nicknameUser1 = usuario.nickname
		sudo.repositorio.borrar('nickname', nicknameUser1)
		sudo.repositorio.cerrarConeccion()	
	}
	
}
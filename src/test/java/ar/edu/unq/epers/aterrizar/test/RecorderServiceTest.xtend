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
import ar.edu.unq.epers.aterrizar.exceptions.RegistrationException
import ar.edu.unq.epers.aterrizar.exceptions.MyValidateException
import ar.edu.unq.epers.aterrizar.exceptions.UsuarioNoEstaEnElServicioException
import ar.edu.unq.epers.aterrizar.exceptions.ChangingPasswordException
import ar.edu.unq.epers.aterrizar.exceptions.MyLoginException
import ar.edu.unq.epers.aterrizar.servicios.RecorderService

class RecorderServiceTest{
	
	CreadorDeCodigos creadorDeCodigosMock
	EnviadorDeMails enviadorDeMailsMock
	CreadorDeMails creadorDeMailsMock
	Usuario pepillo
	RecorderService sudo
	String codigoFromMock
	Mail mailFromMock
	int cantidadDeUsuariosCreados
	
	Usuario cepillo
	
	/*
	 * Solo testeo los metodos que me parecieron mas importantes del servicio, los que no se testearon del servicio fueron
	 * porque estos se usan de soporte en los importantes.
	 */
	
	@Before
	def void setUp(){
		pepillo = new Usuario=>[
			nombre = 'pepe'
			apellido = 'garcia'
			nickname = 'pepillo'
			password = '1234'
			email = 'pepillo@gmail.com'
			fechaDeNacimiento = Date.valueOf('1994-12-21')
			codigo = 'nousado'
		]
		
		cepillo = new Usuario=>[
			nombre = 'juan'
			apellido = 'lopez'
			nickname = 'cepillo'
			password = '1234'
			email = 'cepillo@gmail.com'
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
		Mockito.when(creadorDeMailsMock.crearMailParaUsuario('registrador', pepillo, codigoFromMock)).thenReturn(mailFromMock)
		Mockito.when(creadorDeMailsMock.crearMailParaUsuario('registrador', cepillo, codigoFromMock)).thenReturn(mailFromMock)
		
		cantidadDeUsuariosCreados = 0
		sudo.registrarUsuario(pepillo)
		cantidadDeUsuariosCreados+= 1
		sudo.registrarUsuario(cepillo)
		cantidadDeUsuariosCreados += 1
	}
	
	@Test 
	def void testRegistrarUsuarioQueNoExisteEnElSistema(){


		var primerUsuarioCreadoId = sudo.traerUsuarioPorNickname(pepillo.nickname).id
		
		//primer usuario id >= 1
		assertTrue(1 <= primerUsuarioCreadoId)
		
		assertTrue(sudo.contieneUsuarioPorNickname(pepillo.nickname))
		Mockito.verify(creadorDeCodigosMock, Mockito.times(cantidadDeUsuariosCreados)).crearCodigo()
		Mockito.verify(enviadorDeMailsMock, Mockito.times(cantidadDeUsuariosCreados)).enviarMail(mailFromMock)
		
		Mockito.verify(creadorDeMailsMock).crearMailParaUsuario('registrador', pepillo, codigoFromMock)
		
	}
	
	@Test
	def void testRegistrarOtroUsuarioQueNoExisteEnElSistemaDebeTenerUnIdMayorAlPrimero(){
		val primerUsuarioCreadoId = sudo.traerUsuarioPorNickname(pepillo.nickname).id
		val segundoUsuarioCreadoId = sudo.traerUsuarioPorNickname(cepillo.nickname).id

		assertTrue(primerUsuarioCreadoId < segundoUsuarioCreadoId )
		assertTrue(sudo.contieneUsuarioPorNickname(cepillo.nickname))

		Mockito.verify(creadorDeMailsMock).crearMailParaUsuario('registrador', cepillo, codigoFromMock)

	}
	
	@Test
	def void testRegistrarUsuarioQueYaExisteEnElSistemaArrojaUnaExcepcionDeRegistracion() throws Exception{
		try{
			sudo.registrarUsuario(pepillo)
			fail("registrar no funciona correctamente")
			}	
		catch(RegistrationException expected){
			
		assertTrue(sudo.contieneUsuarioPorNickname(pepillo.nickname))
		
		//Esto significa que los objetos creadorDeCodigos y enviadorDeMails fueron llamados  por la cantidad
		//veces que usuarios creados en el sistema
		//setUp y no en este metodo
		
		Mockito.verify(creadorDeCodigosMock, Mockito.times(cantidadDeUsuariosCreados)).crearCodigo()
		Mockito.verify(enviadorDeMailsMock, Mockito.times(cantidadDeUsuariosCreados)).enviarMail(mailFromMock)
		}				
	}

	@Test 
	def void testValidarUsuarioQueAunNoValidoSuCodigoCambiaSuCodigoAUsado(){

		var codenousado = pepillo.codigo
		
		sudo.validar(pepillo, codenousado)
		var user = sudo.traerUsuarioPorNickname(pepillo.nickname)
		
		assertTrue(user.estaValidado())
	}
		
	@Test
	def void testValidarUsuarioQueIngresaMalSuCodigoArrojaUnaExcepcionDeValidacion(){

		var codigoerroneo = 'codigoerroneo'
		try{
			sudo.validar(pepillo, codigoerroneo)
			fail("validar no funciona bien")
			}
		catch(MyValidateException expected){
			
			var userCode = sudo.traerUsuarioPorNickname(pepillo.nickname).codigo
			
			assertFalse(userCode.equals(codigoerroneo))			
		}	
	}
	
	@Test
	def void testLogearUnUsuarioQueNoFueValidadoEnElSistemaArrojaUnaExcepcionDeLogeo(){
		try{
			sudo.login(pepillo.nickname, pepillo.password)
			fail('logear no funciona correctamente')
		}		
		catch(MyLoginException expected){
			var usuario = sudo.traerUsuarioPorNickname(pepillo.nickname)
			assertFalse(usuario.estaValidado)
		}
	}
	
	@Test
	def void testLogearUnUsuarioConContrasenhaIncorrectaArrojaUnaExcepcionDeLogeo(){
		var wrongPassword = 'wrong'
		try{
			sudo.login(pepillo.nickname, wrongPassword)
			fail('login no funciona')
		}
		catch(MyLoginException expected){
			var actualPassword = sudo.traerUsuarioPorNickname(pepillo.nickname).password
			assertFalse(wrongPassword.equals(actualPassword))
		}
	}
	
	@Test
	def void testLogearUnUsuarioQueEstaValidadoEnElSistemaLoLogeaCorrectamente(){
		var nick = pepillo.nickname
		sudo.validar(pepillo, 'nousado')
		var usuarioFromRepo = sudo.login(nick, pepillo.password)
		
		assertEquals(nick, usuarioFromRepo.nickname)
	}
	
	
	@Test(expected=ChangingPasswordException)
	def void testCambiarContrasenhaPorLaMismaContrasenhaArrojaUnaExcepcionDeCambiarContrasenha(){
		var actualPw = pepillo.password
		var expectedPw = '1234'
		sudo.changePassword(pepillo, expectedPw)
		assertEquals(actualPw, expectedPw)
	}
	
	@Test
	def void testCambiarContrasenhaPorOtraActualizaLaBaseDeDatos(){
		var nueva = 'dificil'
		sudo.changePassword(pepillo, nueva)
		var newPassword = sudo.traerUsuarioPorNickname(pepillo.nickname).password 
		assertEquals(nueva, newPassword)
	}
	
	@Test(expected=UsuarioNoEstaEnElServicioException)
	def void testTraerUnUsuarioQueNoExisteEnElRepositorioArrojaUnaExcepcionDeUsuarioNoEncontrado(){
		var pw = 'doesnt care'
		var nickname = 'pichu'
		sudo.login(nickname, pw)
		assertFalse(sudo.contieneUsuarioPorNickname(nickname))
	}
	
	@After
	def void testBorrarUsuarioQueFueCreadoEnSetUp(){
		sudo.repositorio.borrar('nickname', pepillo.nickname)
		sudo.repositorio.borrar('nickname', cepillo.nickname)
		sudo.repositorio.cerrarConeccion()	
	}
	
}
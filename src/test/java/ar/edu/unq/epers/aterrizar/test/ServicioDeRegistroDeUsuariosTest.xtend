package ar.edu.unq.epers.aterrizar.test

import org.junit.Test

import static org.junit.Assert.*
import org.mockito.Mockito
import org.junit.Before
import ar.edu.unq.epers.aterrizar.domain.Usuario
import java.sql.Date
import org.junit.After
import ar.edu.unq.epers.aterrizar.exceptions.RegistrationException
import ar.edu.unq.epers.aterrizar.exceptions.MyValidateException
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeRegistroDeUsuarios
import ar.edu.unq.epers.aterrizar.exceptions.UsuarioNoExisteException
import ar.edu.unq.epers.aterrizar.domain.mensajes.CreadorDeCodigos
import ar.edu.unq.epers.aterrizar.domain.mensajes.EnviadorDeMails
import ar.edu.unq.epers.aterrizar.domain.mensajes.CreadorDeMails
import ar.edu.unq.epers.aterrizar.domain.mensajes.Mail

class ServicioDeRegistroDeUsuariosTest{
	
	CreadorDeCodigos creadorDeCodigosMock
	EnviadorDeMails enviadorDeMailsMock
	CreadorDeMails creadorDeMailsMock
	Usuario pepillo
	ServicioDeRegistroDeUsuarios sudo
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
		
		
		sudo = new ServicioDeRegistroDeUsuarios()
		creadorDeCodigosMock = Mockito.mock(CreadorDeCodigos)
		enviadorDeMailsMock = Mockito.mock(EnviadorDeMails)
		creadorDeMailsMock = Mockito.mock(CreadorDeMails)
		
		sudo.creadorDeCodigos = creadorDeCodigosMock
		sudo.enviadorDeMails = enviadorDeMailsMock
		sudo.creadorDeMails = creadorDeMailsMock
		
		var url = "jdbc:mysql://localhost:3306/aterrizar"
		var user = 'root'
		var pass = 'root'
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


		var primerUsuarioCreadoId = sudo.traerUsuarioPorNickname(pepillo.nickname).idUsuario
		
		//primer usuario id >= 1
		assertTrue(1 <= primerUsuarioCreadoId)
		
		assertTrue(sudo.contieneUsuarioPorNickname(pepillo.nickname))
		Mockito.verify(creadorDeCodigosMock, Mockito.times(cantidadDeUsuariosCreados)).crearCodigo()
		Mockito.verify(enviadorDeMailsMock, Mockito.times(cantidadDeUsuariosCreados)).enviarMail(mailFromMock)
		
		Mockito.verify(creadorDeMailsMock).crearMailParaUsuario('registrador', pepillo, codigoFromMock)
		
	}
	
	@Test
	def void testRegistrarOtroUsuarioQueNoExisteEnElSistemaDebeTenerUnIdMayorAlPrimero(){
		
		val primerUsuarioCreadoId = sudo.traerUsuarioPorNickname(pepillo.nickname).idUsuario
		val segundoUsuarioCreadoId = sudo.traerUsuarioPorNickname(cepillo.nickname).idUsuario

		assertTrue(primerUsuarioCreadoId < segundoUsuarioCreadoId )
		assertTrue(sudo.contieneUsuarioPorNickname(cepillo.nickname))

		Mockito.verify(creadorDeMailsMock).crearMailParaUsuario('registrador', cepillo, codigoFromMock)

	}

	@Test(expected=RegistrationException)
	def void testRegistrarUsuarioQueYaExisteEnElSistemaArrojaUnaExcepcionDeRegistracion() throws Exception{
		
		//arroja una excepcion
		sudo.registrarUsuario(pepillo)
			
		assertTrue(sudo.contieneUsuarioPorNickname(pepillo.nickname))
		
		//Esto significa que los objetos creadorDeCodigos y enviadorDeMails fueron llamados  por la cantidad
		//de veces como usuarios creados en el sistema, es decir creados en el setUp y no en este metodo
		
		Mockito.verify(creadorDeCodigosMock, Mockito.times(cantidadDeUsuariosCreados)).crearCodigo()
		Mockito.verify(enviadorDeMailsMock, Mockito.times(cantidadDeUsuariosCreados)).enviarMail(mailFromMock)
	}

	@Test 
	def void testValidarUsuarioQueAunNoValidoSuCodigoCambiaSuCodigoAUsado(){

		var codenousado = pepillo.codigo
		
		sudo.validar(pepillo, codenousado)
		var user = sudo.traerUsuarioPorNickname(pepillo.nickname)
		
		assertTrue(user.estaValidado())
	}
		
	@Test(expected=MyValidateException)
	def void testValidarUsuarioQueIngresaMalSuCodigoArrojaUnaExcepcionDeValidacion(){

		var codigoerroneo = 'codigoerroneo'
		//arroja un error		
		sudo.validar(pepillo, codigoerroneo)
			
		var userCode = sudo.traerUsuarioPorNickname(pepillo.nickname).codigo
			
		assertFalse(userCode.equals(codigoerroneo))			
	}
	
	@Test(expected=MyValidateException)
	def void testLogearUnUsuarioQueNoFueValidadoEnElSistemaArrojaUnaExcepcionDeLogeo(){
		//arroja una excepcion
		sudo.login(pepillo.nickname, pepillo.password)
		var usuario = sudo.traerUsuarioPorNickname(pepillo.nickname)
		assertFalse(usuario.estaValidado)
	}
	
	@Test(expected=MyValidateException)
	def void testLogearUnUsuarioConContrasenhaIncorrectaArrojaUnaExcepcionDeLogeo(){

		var wrongPassword = 'wrong'
		//arroja una excepcion
		sudo.login(pepillo.nickname, wrongPassword)
		var actualPassword = sudo.traerUsuarioPorNickname(pepillo.nickname).password
		assertFalse(wrongPassword.equals(actualPassword))
	}
	
	@Test
	def void testLogearUnUsuarioQueEstaValidadoEnElSistemaLoLogeaCorrectamente(){
		
		var nick = pepillo.nickname
		sudo.validar(pepillo, 'nousado')
		var usuarioFromRepo = sudo.login(nick, pepillo.password)
		
		assertEquals(nick, usuarioFromRepo.nickname)
	}
	
	
	@Test(expected=MyValidateException)
	def void testCambiarContrasenhaPorLaMismaContrasenhaArrojaUnaExcepcionDeCambiarContrasenha(){
		
		var actualPw = pepillo.password
		var expectedPw = '1234'
		sudo.changePassword(pepillo, expectedPw)
		assertEquals(actualPw, expectedPw)
	}
	
	@Test
	def void testCambiarContrasenhaPorOtraActualizaLaBaseDeDatos(){
		
		var nuevaPassword = 'dificil'
		sudo.changePassword(pepillo, nuevaPassword)
		var newPasswordFromRepo = sudo.traerUsuarioPorNickname(pepillo.nickname).password 
		assertEquals(nuevaPassword, newPasswordFromRepo)
	}
	
	@Test(expected=UsuarioNoExisteException)
	def void testTraerUnUsuarioQueNoExisteEnElRepositorioArrojaUnaExcepcionDeUsuarioNoEncontrado(){
		var pw = 'doesnt care'
		var nickname = 'pichu'
		sudo.login(nickname, pw)
		assertFalse(sudo.contieneUsuarioPorNickname(nickname))
	}
	
	@After
	def void testBorrarUsuarioQueFueCreadoEnSetUpYCerrarConexion(){
	
		sudo.eliminarUsuario(pepillo)
		sudo.eliminarUsuario(cepillo)		
		sudo.repositorio.cerrarConeccion()
	}
	
}
package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.Test
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeCacheDePerfiles
import ar.edu.unq.epers.aterrizar.domain.perfiles.Perfil
import org.junit.Assert
import org.junit.After
import ar.edu.unq.epers.aterrizar.domain.perfiles.DestinoPost
import ar.edu.unq.epers.aterrizar.domain.perfiles.visibility.Visibility

class ServicioCacheDePerfilesTest {

	ServicioDeCacheDePerfiles cache

	Perfil pepe

	DestinoPost post1

	DestinoPost post2

	DestinoPost post3

	@Before
	def void setUp() {
		cache = new ServicioDeCacheDePerfiles()
		pepe = new Perfil()
		pepe.nickname = "pepe"

		post1 = new DestinoPost() => [
			id = "1"
			destino = "Argentina"
		]
		post2 = new DestinoPost() => [
			id = "2"
			destino = "Brasil"
			visibility = Visibility.PUBLIC
		]
		post3 = new DestinoPost() => [
			id = "3"
			destino = "Brasil"
			visibility = Visibility.ONLYFRIENDS
		]

		pepe.addPost(post1)
		pepe.addPost(post2)
		pepe.addPost(post3)
		cache.cache(pepe)

	}

	@Test
	def void testServicioDeCaching() {

		Assert.assertTrue(cache.cached('pepe'))
	}

	@Test
	def void testGetPublicosYPrivadosDevuelve2Post() {
		var perfil = cache.get('pepe', false, true)
		var p1 = perfil.getPost(post1)
		Assert.assertEquals("1", p1.id)
		var p2 = perfil.getPost(post2)
		Assert.assertEquals("2", p2.id)
		var ps = perfil.posts.length
		Assert.assertEquals(2, ps)
	}

	@Test
	def void testGetPublicosDevuelveUnPerfilConUnPost() {
		var perfil = cache.get('pepe', false, false)
		var ps = perfil.posts.length
		Assert.assertEquals(1, ps)
	}

	@Test
	def void testGetPublicosYSoloAmigosDevuelveUnPerfilConUnPost() {
		var perfil = cache.get('pepe', true, false)
		var ps = perfil.posts.length
		Assert.assertEquals(2, ps)
	}

	@After
	def void after() {
		cache.delete('pepe')
	}
}

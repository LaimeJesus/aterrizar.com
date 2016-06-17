package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.Test
import ar.edu.unq.epers.aterrizar.servicios.ServicioDeCacheDePerfiles
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil
import org.junit.Assert
import org.junit.After
import ar.edu.unq.epers.aterrizar.domain.redsocial.DestinoPost

class ServicioCacheDePerfilesTest {

	ServicioDeCacheDePerfiles cache

	Perfil pepe

	DestinoPost post1

	@Before
	def void setUp() {
		cache = new ServicioDeCacheDePerfiles()
		pepe = new Perfil()
		pepe.nickname = "pepe"

		post1 = new DestinoPost() => [
			id = "1"
			destino = "Argentina"
		]

		pepe.addPost(post1)
		cache.cache(pepe)

	}

	@Test
	def void testServicioDeCaching() {

		Assert.assertTrue(cache.cached('pepe'))
	}

	@Test
	def void testGetPublicosYPrivados() {
		var perfil = cache.get('pepe', false, true)
		var p = perfil.getPost(post1)
		Assert.assertTrue(p.id == "1")
	}

	@Test
	def void testGetPublicosDevuelveUnPerfilSinPosts() {
		var perfil = cache.get('pepe', false, false)
		Assert.assertTrue(perfil.posts.length == 0)
	}

	@Test
	def void testGetPublicosYSoloAmigosDevuelveUnPerfilSinPosts() {
		var perfil = cache.get('pepe', true, false)
		Assert.assertTrue(perfil.posts.length == 0)
	}

	@After
	def void after() {
		cache.delete('pepe')
	}
}

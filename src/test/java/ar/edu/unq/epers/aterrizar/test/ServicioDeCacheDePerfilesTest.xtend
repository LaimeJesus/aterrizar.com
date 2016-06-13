package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.Test
import org.junit.After
import ar.edu.unq.epers.aterrizar.persistence.cassandra.RepositorioPerfiles
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil
import com.datastax.driver.core.Cluster
import ar.edu.unq.epers.aterrizar.domain.redsocial.DestinoPost

class ServicioDeCacheDePerfilesTest {

	RepositorioPerfiles repo

	Perfil perfil
	
	DestinoPost post

	@Before
	def void setUp() {

		//127.0.0.1:9042
		repo = new RepositorioPerfiles()
		perfil = new Perfil()
		perfil.nickname = "PEPE"
		perfil.idPerfil = "1"
		
		post = new DestinoPost()
		post.id = "1"
		post.destino = "Berazategui"
		
		perfil.addPost(post)
		
		repo.persist(perfil)
	}

	@Test
	def void testTraerUnPerfilLoAgregaALServicioDeCache() {
		var fromRepo = repo.get("", "PEPE")
		println(fromRepo.nickname)
	}

	@After
	def void after() {

		//		mapper.delete(pdto)
		repo.actualSession.close()
		repo.connector.cluster.close()
	}

	def connect(String node) {
		var cluster = Cluster.builder().addContactPoint(node).build();
		cluster
	}

}

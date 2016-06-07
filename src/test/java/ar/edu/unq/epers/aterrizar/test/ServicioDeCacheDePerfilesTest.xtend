package ar.edu.unq.epers.aterrizar.test

import org.junit.Before
import org.junit.Test
import org.junit.After
import ar.edu.unq.epers.aterrizar.persistence.cassandra.RepositorioPerfiles
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil
import com.datastax.driver.mapping.MappingManager
import ar.edu.unq.epers.aterrizar.persistence.cassandra.PerfilDTO
import com.datastax.driver.mapping.Mapper

class ServicioDeCacheDePerfilesTest {
	
	RepositorioPerfiles repo
	
	Perfil perfil
	
	Mapper<PerfilDTO> mapper
	
	PerfilDTO pdto
	
	@Before
	def void setUp(){
		var aterrizar = "aterrizar"
		repo = new RepositorioPerfiles(aterrizar)
		
		perfil = new Perfil()
		perfil.nickname = "PEPE"
		
		mapper = new MappingManager(repo.session()).mapper(PerfilDTO)
		pdto = new PerfilDTO()
		pdto.nickname = "PIPO"
		mapper.save(pdto)
	}
	@Test
	def void testTraerUnPerfilLoAgregaALServicioDeCache(){
		var fromRepo = mapper.get("PIPO")
		println(fromRepo.nickname)
	}
	
	@After
	def void after(){
//		mapper.delete(pdto)
	} 
}
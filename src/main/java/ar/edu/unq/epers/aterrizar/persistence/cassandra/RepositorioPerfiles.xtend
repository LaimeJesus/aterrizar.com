package ar.edu.unq.epers.aterrizar.persistence.cassandra

import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RepositorioPerfiles extends RepositorioCassandra<Perfil> {

	new(String ks) {
		super(ks)
	}
	
	override table() {
		"Perfil"
	}

	override fields(Perfil object) {
		var fields = new ArrayList<String>
		fields.add("nickname")
		fields
	}

	override values(Perfil object) {
		var values = new ArrayList<String>
		values.add(object.nickname)
		values
	}

	override types(Perfil t) {
		new ArrayList<String>
	}

	override createTable() {
		
		var fytc = " (id text, likesAdmin LikeAdmin, visibility Visibility, comment text);"
		var comment = "CREATE TYPE DestinoPost" + fytc
				
		var fytdp = " (id text PRIMARY KEY, comments List<Comment>, likesAdmin LikeAdmin, visibility Visibility, destino text);"
		var destinoPost = "CREATE TYPE DestinoPost" + fytdp

//		var fieldsAndTypes = "(nickname text PRIMARY KEY, posts List<DestinoPost>, id uuid);"
		var fieldsAndTypes = "(nickname text PRIMARY KEY);"
		var query = "CREATE TABLE IF NOT EXISTS " + table + fieldsAndTypes
		
		session.execute(query)

	}

}

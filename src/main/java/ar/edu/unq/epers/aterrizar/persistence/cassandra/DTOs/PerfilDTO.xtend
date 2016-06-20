package ar.edu.unq.epers.aterrizar.persistence.cassandra.DTOs

import org.eclipse.xtend.lib.annotations.Accessors
import com.google.common.base.Objects
import com.datastax.driver.mapping.annotations.Table
import com.datastax.driver.mapping.annotations.PartitionKey
import ar.edu.unq.epers.aterrizar.domain.perfiles.visibility.Visibility
import java.util.List
import com.datastax.driver.mapping.annotations.Frozen
import com.datastax.driver.mapping.annotations.Column
import ar.edu.unq.epers.aterrizar.domain.perfiles.DestinoPost
import java.util.ArrayList
import javax.persistence.Enumerated
import javax.persistence.EnumType

/*
 * this class is designed to be used for Cassandra db.
 */
@Accessors
@Table(keyspace="aterrizar", name="Perfil")
class PerfilDTO {
	@PartitionKey(0)
	@Column(name="nickname")
	String nickname = ""

	//	hay que registrar el enum
	@PartitionKey(1)
	@Column(name="visibility")
	@Enumerated(EnumType.STRING)
	Visibility visibility = Visibility.PUBLIC

	@Column(name="idPerfil")
	String idPerfil = ""

	@Frozen("list<frozen <destinoPost>>")
	@Column(name="posts")
	List<DestinoPost> posts = new ArrayList<DestinoPost>()

	new() {
	}

	override equals(Object other) {
		if(other instanceof PerfilDTO) {
			var acc = other as PerfilDTO
			return nickname.equals(acc.nickname)
		}
		false
	}

	override hashCode() {
		Objects.hashCode(nickname)
	}

}

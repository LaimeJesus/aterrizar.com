package ar.edu.unq.epers.aterrizar.persistence.cassandra.DTOs

import org.eclipse.xtend.lib.annotations.Accessors
import com.google.common.base.Objects
import com.datastax.driver.mapping.annotations.Table
import com.datastax.driver.mapping.annotations.PartitionKey
import ar.edu.unq.epers.aterrizar.domain.redsocial.visibility.Visibility
import java.util.List
import com.datastax.driver.mapping.annotations.Frozen
import com.datastax.driver.mapping.annotations.Column

/*
 * this class is designed to be used for Cassandra db.
 */
@Accessors
@Table(keyspace="aterrizar", name="Perfil")
class PerfilDTO {
	@PartitionKey(0)
	String nickname

	//	hay que registrar el enum
	@PartitionKey(1)
	Visibility visibility
	
	@PartitionKey(2)
	String idPerfil
	@Frozen("list<frozen <destinoPost>>")
	@Column(name="posts")
	List<DestinoDTO> posts

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

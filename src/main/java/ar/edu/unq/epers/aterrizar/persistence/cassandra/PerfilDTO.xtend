package ar.edu.unq.epers.aterrizar.persistence.cassandra

import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.annotations.Table
import com.datastax.driver.mapping.annotations.PartitionKey
import com.google.common.base.Objects

/*
 * this class is designed to be used for Cassandra db.
 */

@Accessors
@Table(keyspace = "aterrizar", name="Perfil")
class PerfilDTO {
	@PartitionKey
	String nickname
	
	new(){}
	
	override equals(Object other){
		if(other instanceof PerfilDTO){
			var acc = other as PerfilDTO
			return nickname.equals(acc.nickname)
		}
		false
	}
	override hashCode(){
		Objects.hashCode(nickname)
	}
	
}
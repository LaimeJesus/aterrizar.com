package ar.edu.unq.epers.aterrizar.persistence.cassandra.DTOs

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
//@UDT(keyspace="aterrizar", name="Like")
class LikeDTO {
	String id
	String nickname
}

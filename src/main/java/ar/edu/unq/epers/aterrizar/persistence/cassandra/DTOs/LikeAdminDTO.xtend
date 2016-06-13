package ar.edu.unq.epers.aterrizar.persistence.cassandra.DTOs

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
//@UDT(keyspace="aterrizar", name="LikesAdmin")
class LikeAdminDTO {
	List<LikeDTO> meGusta
	List<LikeDTO> noMeGusta
}

package ar.edu.unq.epers.aterrizar.domain.redsocial

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Like {

	//	Perfil perfil
	String id
	String nickname
	new(){
		
	}
	new(Perfil p) {
		id = p.idPerfil
		nickname = p.nickname
	}

	override boolean equals(Object obj) {
		if(obj == this) {
			return true;
		}
		if(obj == null || obj.getClass() != this.getClass()) {
			return false;
		}

		var guest = obj as Like;
		return nickname == guest.nickname || id == guest.id
	}

	override int hashCode() {

		val prime = 31;
		var result = 1;
		result = prime * result
		if(nickname != null) {
			result = result + nickname.hashCode()
		}
		return result;
	}
}

package ar.edu.unq.epers.aterrizar.domain.redsocial.visibility;

import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil;

public enum Visibility {
	JUSTFRIENDS {

		public boolean puedeVer(Perfil p1, Perfil p2) {
			return false;
		}
	},
	PUBLIC {
		public boolean puedeVer(Perfil p1, Perfil p2) {
			return true;
		}
	},
	PRIVATE{
		public boolean puedeVer(Perfil p1, Perfil p2){
			return p1.getNickname().equals(p2.getNickname());
		}
	};

	public abstract boolean puedeVer(Perfil p1, Perfil p2);
}

package ar.edu.unq.epers.aterrizar.domain.redsocial.visibility;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonValue;

import ar.edu.unq.epers.aterrizar.domain.redsocial.Comment;
import ar.edu.unq.epers.aterrizar.domain.redsocial.DestinoPost;
import ar.edu.unq.epers.aterrizar.domain.redsocial.Perfil;

public enum Visibility {
	
	JUSTFRIENDS {

		public boolean puedeVer(Perfil p1, Perfil p2) {
			return true;
		}
		@JsonValue
		public String getName(){
			return "JUSTFRIENDS";
		}
	},
	PUBLIC {
		public boolean puedeVer(Perfil p1, Perfil p2) {
			return true;
		}
		@JsonValue
		public String getName(){
			return "PUBLIC";
		}		
	},
	PRIVATE{
		public boolean puedeVer(Perfil p1, Perfil p2){
			return p1.getNickname().equals(p2.getNickname());
		}
		@JsonValue
		public String getName(){
			return "PRIVATE";
		}
	};

	public abstract boolean puedeVer(Perfil p1, Perfil p2);

	public static void changeToPublic(DestinoPost p){
		p.setVisibility(PUBLIC);
	}
	public static void changeToPublic(Comment c){
		c.setVisibility(PUBLIC);
	}
	public static void changeToPrivate(DestinoPost p){
		p.setVisibility(PRIVATE);
	}
	public static void changeToPrivate(Comment c){
		c.setVisibility(PRIVATE);
	}	
	public static void changeToJustFriend(DestinoPost p){
		p.setVisibility(JUSTFRIENDS);
	}
	public static void changeToJustFriend(Comment c){
		c.setVisibility(JUSTFRIENDS);
	}
}

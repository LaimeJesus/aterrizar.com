package ar.edu.unq.epers.aterrizar.domain.redsocial.visibility;



import ar.edu.unq.epers.aterrizar.domain.redsocial.Comment;
import ar.edu.unq.epers.aterrizar.domain.redsocial.DestinoPost;

public enum Visibility{
	
	JUSTFRIENDS, PUBLIC, PRIVATE;
	
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

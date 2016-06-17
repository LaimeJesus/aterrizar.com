package ar.edu.unq.epers.aterrizar.domain.redsocial.visibility;

import ar.edu.unq.epers.aterrizar.domain.redsocial.Comment;
import ar.edu.unq.epers.aterrizar.domain.redsocial.DestinoPost;

public enum Visibility {
	
	JUSTFRIENDS, PUBLIC, PRIVATE;
	
	public void changeTo(DestinoPost p){
		p.setVisibility(this);
	}
	
	public void changeTo(Comment c){
		c.setVisibility(this);
	}
	
}

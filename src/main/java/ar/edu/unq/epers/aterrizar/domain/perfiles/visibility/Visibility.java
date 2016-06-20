package ar.edu.unq.epers.aterrizar.domain.perfiles.visibility;

import ar.edu.unq.epers.aterrizar.domain.perfiles.Comment;
import ar.edu.unq.epers.aterrizar.domain.perfiles.DestinoPost;

public enum Visibility {
	
	ONLYFRIENDS, PUBLIC, PRIVATE;
	
	public void changeTo(DestinoPost p){
		p.setVisibility(this);
	}
	
	public void changeTo(Comment c){
		c.setVisibility(this);
	}
	
}

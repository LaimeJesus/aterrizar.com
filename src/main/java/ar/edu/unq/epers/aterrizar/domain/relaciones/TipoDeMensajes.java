package ar.edu.unq.epers.aterrizar.domain.relaciones;

import org.neo4j.graphdb.RelationshipType;

public enum TipoDeMensajes implements RelationshipType{
	
	EMISOR, RECEPTOR
}

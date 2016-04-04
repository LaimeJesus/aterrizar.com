package ar.edu.unq.epers.aterrizar.domain

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List

@Accessors
class Vuelo {
	int idVuelo
	List<Tramo> tramos
	 
}
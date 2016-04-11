package ar.edu.unq.epers.aterrizar.domain.categorias;

public enum TipoDeCategoria {

	BUSINESS(0), PRIMERA(0), TURISTA(0);
	
	public int factorPrecio;
	
	TipoDeCategoria(int factorPrecio){
		this.factorPrecio = factorPrecio;
	}
	
	public int factorPrecio(){
		return this.factorPrecio;
	}
	
}

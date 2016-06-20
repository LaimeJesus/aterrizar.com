package ar.edu.unq.epers.aterrizar.domain.perfiles
import java.util.List
import org.mongojack.ObjectId
import com.fasterxml.jackson.annotation.JsonProperty
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.domain.perfiles.visibility.Visibility;
import ar.edu.unq.epers.aterrizar.exceptions.NoExistePostException
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Perfil {

	String nickname
	List<DestinoPost> posts

	@ObjectId
	@JsonProperty("_id")
	String idPerfil

	new() {
		posts = new ArrayList<DestinoPost>()
	}

	new(String nick) {
		posts = new ArrayList<DestinoPost>()
		nickname = nick
	}

	///////////////////////////////////////
	//POSTS
	///////////////////////////////////////
	def void toPublic(DestinoPost p) {

		Visibility.PUBLIC.changeTo(getPost(p))
	}

	def void toPrivate(DestinoPost p) {
		Visibility.PRIVATE.changeTo(getPost(p))
	}

	def void toOnlyFriends(DestinoPost p) {
		Visibility.ONLYFRIENDS.changeTo(getPost(p))
	}

	def addPost(DestinoPost p) {
		posts.add(p)
	}

	def deletePost(DestinoPost p) {
		posts.remove(p)
	}

	def DestinoPost getPost(DestinoPost p) {
		for (post : posts) {
			if(post.destino == p.destino) {
				return post
			}
		}
		throw new NoExistePostException("No existe post con destino a: " + p.destino)
	}

	///////////////////////////////////////
	//COMMENTS
	///////////////////////////////////////
	def void toPrivate(DestinoPost p, Comment c) {
		getPost(p).cambiarAPrivado(c)
	}

	def void toPublic(DestinoPost p, Comment c) {
		getPost(p).cambiarAPublico(c)
	}

	def void toOnlyFriends(DestinoPost p, Comment c) {
		getPost(p).cambiarASoloAmigos(c)
	}

	def void commentToPost(DestinoPost post, Comment comment) {

		getPost(post).addComment(comment)
	}

	///////////////////////////////////////
	//likes
	///////////////////////////////////////
	def void agregarMeGusta(Perfil perfil, DestinoPost post) {
		getPost(post).meGusta(perfil)
	}

	def void agregarNoMeGusta(Perfil perfil, DestinoPost post) {
		getPost(post).noMeGusta(perfil)
	}

	def void agregarMeGusta(Perfil per, DestinoPost p, Comment c) {
		getPost(p).getComment(c).meGusta(per)
	}

	def void agregarNoMeGusta(Perfil per, DestinoPost p, Comment c) {
		getPost(p).getComment(c).noMeGusta(per)
	}
	
	def void quitarMeGusta(Perfil q, DestinoPost p){
		getPost(p).quitarMeGusta(q)
	}
	
	def void quitarNoMeGusta(Perfil q, DestinoPost p){
		getPost(p).quitarNoMeGusta(q)
	}

	def void quitarMeGusta(Perfil q, DestinoPost p, Comment c){
		getPost(p).getComment(c).quitarMeGusta(q)
	}
	
	def void quitarNoMeGusta(Perfil q, DestinoPost p, Comment c){
		getPost(p).getComment(c).quitarNoMeGusta(q)
	}
	
	////////////////////////////////////////
	//
	////////////////////////////////////////
	def getComments(DestinoPost post) {
		getPost(post).comments
	}

	def cantidadDeMeGusta(DestinoPost post) {
		getPost(post).cantidadMeGusta()
	}

	def cantidadDeMeGusta(DestinoPost post, Comment c) {
		getPost(post).getComment(c).cantidadMeGusta()
	}

	def cantidadDeNoMeGusta(DestinoPost p) {
		getPost(p).cantidadNoMeGusta()
	}

	def cantidadDeNoMeGusta(DestinoPost post, Comment c) {
		getPost(post).getComment(c).cantidadNoMeGusta()
	}

	def List<DestinoPost> getPublicPosts() {
		getPosts.filter[it.visibility == Visibility.PUBLIC].toList
	}

	def List<DestinoPost> getPrivatePosts() {
		getPosts.filter[it.visibility == Visibility.PRIVATE].toList
	}

	def List<DestinoPost> getJustFriendsPosts() {
		getPosts.filter[it.visibility == Visibility.ONLYFRIENDS].toList
	}
}

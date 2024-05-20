
class Personaje{
	var property estrategia
	var property espiritualidad
	var poderes = []

	method capacidadDeBatalla() = poderes.sum({poder => poder.capacidadDeBatalla(self)})
	method mejorPoder() = poderes.max({poder => poder.capacidadDeBatalla(self)})
	method puedeEnfrentar(peligro) = self.capacidadDeBatallaEsSuperior(peligro) && self.manejaRadioctividad(peligro)
	method capacidadDeBatallaEsSuperior(peligro)= self.capacidadDeBatalla() > peligro.capacidadDeBatalla()
	method inmuneAlaRadiacion() = poderes.any({poder => poder.inmuneAlaRadiacion()})

	method manejaRadioctividad(peligro) {
		if (peligro.desechosRadiactivos()){  return self.inmuneAlaRadiacion()	}
		else return true	 
		} 	

	method enfrentar(peligro) {
		if (not self.puedeEnfrentar(peligro)) self.error("No puedo enfrentar ese peligro")
		estrategia += peligro.nivelDeComplejidad()
	}
}



class Poder{
	
	method capacidadDeBatalla(personaje) = (self.agilidad(personaje) + self.fuerza(personaje)) * self.habilidadEspecial(personaje)
	method agilidad(personaje) 
	method fuerza(personaje) 
	method habilidadEspecial(personaje) = personaje.espiritualidad() + personaje.estrategia() 
	method inmuneAlaRadiacion()	
}



class Velocidad inherits Poder{
	const rapidez
	override method agilidad(personaje) = personaje.estrategia() * rapidez
	override method fuerza(personaje) = personaje.espiritualidad() * rapidez
	override method inmuneAlaRadiacion() = false	
}


class Vuelo inherits Poder{
	const alturaMax
	const energiaDespegue
	override method agilidad(personaje) = personaje.estrategia() * alturaMax / energiaDespegue
	override method fuerza(personaje) = personaje.espiritualidad() + alturaMax - energiaDespegue 
	override method inmuneAlaRadiacion() = alturaMax > 200
}



class PoderAmplificado inherits Poder{	
	const poderBase
	const numeroAmplificador
	override method agilidad(personaje) = poderBase.agilidad(personaje)
	override method fuerza(personaje) = poderBase.fuerza(personaje)
	override method habilidadEspecial(personaje) = poderBase.habilidadEspecial(personaje)  * numeroAmplificador  
	override method inmuneAlaRadiacion() = true
}

class Equipo{
	var personajes = []

	method miembroMasVulnerable() = personajes.min({ personaje => personaje.capacidadDeBatalla()})

	method calidad() =  personajes.sum({ personaje => personaje.capacidadDeBatalla()}) / personajes.size()

	method mejoresPoderes() = personajes.map({ personaje => personaje.mejorPoder()})	

	method peligroSensato(peligro) =  personajes.all({ p => p.puedeEnfrentar(peligro)})

	method enfrentar(peligro) {
	if (not peligro.loSuperanEnNumero(self.puedeEnfrentar(peligro)))  self.error("No pueden enfrentar ese peligro")
		self.puedeEnfrentar(peligro).forEach({p => p.enfrentar(peligro)})		
		}
	method puedeEnfrentar(peligro) = personajes.filter({p => p.puedeEnfrentar(peligro)})
}



class Peligro{
	const property capacidadDeBatalla = 0
	const property desechosRadiactivos = false
	const property nivelDeComplejidad = 0
	const property personajesSimultaneos = 0
	
	method loSuperanEnNumero(unEquipo) = unEquipo.size() > personajesSimultaneos
}




class Metahumano inherits Personaje{
	override method capacidadDeBatalla() = super() *2
	override method enfrentar(peligro)  {
		super(peligro)
		espiritualidad += peligro.nivelDeComplejidad()
		}
	override method inmuneAlaRadiacion() = true
}

class Mago inherits Metahumano{
	var property poderAcumulado
	override method capacidadDeBatalla() = super() + poderAcumulado
	override method enfrentar(peligro)  {
		if(poderAcumulado > 10) super(peligro)
		poderAcumulado = (poderAcumulado - 5).max(0)
		}
	override method inmuneAlaRadiacion() = true
}
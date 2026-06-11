class Criatura{
    var poderMagico
    method poderMagico() = poderMagico
    const astucia
    var rol
    method esAstuta() //METHOD ABSTRACTO
    method poderOfensivo(){
        return poderMagico * 10 + rol.extra()
    }
    method esFormidable() = self.esAstuta() or self.esExtraordinaria()
    method esExtraordinaria() = rol.esExtraordinaria(self)
    method cambiarDeRol(){
        rol = rol.siguienteRol()
    }
    method perder15Porciento(){
        poderMagico = poderMagico * 0.85
    }
}

class Duende inherits Criatura{
    override method poderOfensivo() = super() * 1.1
    override method esAstuta() = false
}
class Hada inherits Criatura{
    var kilometros = 2
    method aumentarKilometros(unValor){
        kilometros = (kilometros + unValor).min(25)
    }
    override method esAstuta() = astucia > 50
    override method esExtraordinaria(){
        return super() && kilometros > 10
    }
}
object guardian{
    method extra() = 100
    method esExtraordinaria(unaCriatura){
        return unaCriatura.poderMagico() > 50
    }
    method siguienteRol(){
        return new Domador(
            mascotas=[new MascotaMitologica(edad=1, tieneCuernos=false)])
    }
}
object hechicero{
    method extra() = 0
    method esExtraordinaria(unaCriatura)= true
    method siguienteRol() = guardian
}
class Domador{
    const mascotas = []
    method extra() = 150 * mascotas.count({m=>m.tieneCuernos()})
    method eagregarMascota(unaMascota){
        mascotas.add(unaMascota)
    }
    method esExtraordinaria(unaCriatura){
        return unaCriatura.poderMagico() >= 15 &&
        self.todasMascotasVeteranas()
    }
    method todasMascotasVeteranas(){
        return mascotas.all({m=>m.esVeterana()})
    }
    method siguienteRol(){
        if(!self.alMenosUnConCuernos()) self.error("no se puede cambiar el rol")
        return hechicero
    }
    method alMenosUnConCuernos() = mascotas.any({m=>m.tieneCuernos()})
}
class MascotaMitologica{
    const edad
    const tieneCuernos
    method tieneCuernos() = tieneCuernos
    method esVeterana() = edad >= 10
}
class Colonia{
    const criaturas = []
    method atacar(unArea){
        if(self.poderOfensivo() > unArea.poderDefensivo())
            unArea.serUsurpada(self)
        else criaturas.forEach({c=>c.perder15Porciento()})
    }
    method poderOfensivo() = criaturas.sum({c=>c.poderOfensivo()})
    method cantidadCriaturasFormidables() = criaturas.count({c=>c.esFormidable()})
    
}

class Area{
    var colonia = new Colonia()
    method poderDefensivo() 
    method serUsurpada(unaColonia){
        colonia = unaColonia
    }
}
class Castillo inherits Area{
    override method poderDefensivo(){
        return 200 * Colonia.cantidadCriaturasFormidables()
    }
}
class Claro inherits Area{
    override method poderDefensivo() {
        return 100 + Colonia.poderOfensivo()
    }
}
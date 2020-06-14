################################## Products ##################################

# Primero creamos la interfaz para Animal (Product en el diagrama)
class Animal
  def initialize(_data)
    raise NotImplementedError, "#{self.class} no tiene implementado el metodo '#{__method__}'"
  end
  def speak
    raise NotImplementedError, "#{self.class} no tiene implementado el metodo '#{__method__}'"
  end
end

# Definimos los animales Frog y Duck (Concrete Products en el diagrama)
class Frog < Animal
  attr_accessor :name
  def initialize(name)
    @name = name
  end

  def speak
    puts "Ruido de rana"
  end
end


class Duck < Animal
  attr_accessor :name
  def initialize(name)
    @name = name
  end

  def speak
    puts "Cuack cuack"
  end
end

################################ Interface and concrete creators #################################


# Definimos Pond, corresponde a una interfaz para factory (Creator)
class Pond
  def initialize(number_animals)
    @animals = []
    number_animals.times do |i|
      @animals << new_animal("#{i}")
    end
  end
  def show_animals
    @animals.each {|animal| puts animal.name}
  end
end

# Creamos una factory en concreto (ConcreteCreator).
# En este caso es un estanque de patos o fabrica de patos.

class DuckPond < Pond 
  def new_animal(name)
    Duck.new("Duck - #{name}")
  end
end

# Podemos definir una factory de ranas.
class FrogPond < Pond
  def new_animal(name)
    Frog.new("Frog - #{name}")
  end
end
############# Cliente #############

# Implementamos la factory
pond = DuckPond.new(3)
# Revisamos que funciona
pond.show_animals

# frog_pond = FrogPond.new(5)
# frog_pond.show_animals
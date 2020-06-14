# La interfaz Component  define operaciones que pueden ser alteradas por los decoradores.
class Component
  def operation
    raise NotImplementedError, "#{self.class} no tiene implementado el metodo '#{__method__}'"
  end
end
# Queremos saber si A y B hicieron match, actualmente Match A solo permite saber que A le dio like a B.
# Implementacion concreta de un componente del tipo Component.
class MatchA < Component
  def operation
    'Persona A le dio like a B'
  end
end

# La clase base del decorador tiene la misma interfaz que los componentes en concreto.
# El proposito es definir la interfaz para el wrapping, para los decoradores en concreto.
# Incluye un atributo para almacenar el componente wrapped.

class Decorator < Component
  attr_accessor :component

  def initialize(component)
    @component = component
  end

  # El decorador delega el trabajo al componente wrapped.
  def operation
    @component.operation
  end
end

# Añadimos comportamiento para saber que B le dio like a A.
class MatchB < Decorator
  def operation
    puts "#{@component.operation}"
    'Persona B le dio like a A'
  end
end

# Decorador AB
class MatchAB < Decorator
  def operation
    puts "#{@component.operation}"
    "A y B hicieron Match"
  end
end

#################################### Cliente ################################################

# El client_code funciona con todos los objetos utilizando la interfaz de Component.
# Permanece independiente de los componentes en concreto con que se utilice.
def client_code(component)
  # ...

  print "#{component.operation}\n"

  # ...
end

# El componente mas simple, se crea.
simple = MatchA.new
puts 'Client: Tengo un component simple:'
client_code(simple)
puts "\n"

# Se aplica decorador A.
decorator1 = MatchB.new(simple)
puts 'Client: Ahora se ha decorado con ConcreteDecoratorA:'
client_code(decorator1)
puts "\n"

# Se aplica decorador B.
decorator2 = MatchAB.new(decorator1)
puts 'Client: Ahora se ha decorado con ConcreteDecoratorB:'
client_code(decorator2)
puts "\n"

puts "#####################################################"
puts 'Client: Ahora puedo revisar todo el flujo'
complete_funcionality = MatchAB.new(MatchB.new(MatchA.new))
client_code(complete_funcionality)
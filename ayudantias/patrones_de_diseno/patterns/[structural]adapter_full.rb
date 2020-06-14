# Target define una interfaz a ser utilizada por el cliente. Esta solo implementa el metodo request.

class Target
  # @return [String]
  def request
    'Target: The default target\'s behavior.'
  end
end

# Adaptee corresponde a una clase que entrega informacion, sin embargo, no podemos obtener el request
# dada la forma en que viene implementado, ademas tenemos la restriccion de no modificar este metodo.

class Adaptee
  # @return [String]
  def specific_request
    '.eetpadA eht fo roivaheb laicepS'
  end
end

# El adapter debe ser capaz de tomar el adaptee y hacerlo compatible con la interfaz del cliente.
# Además debe hacer el text legible.
class Adapter < Target

  def initialize(adaptee)
    @adaptee = adaptee
  end

  def request
    "Adapter: (TRADUCIDO) #{@adaptee.specific_request.reverse!}\n"
  end
end

# client_code soporta todas las clases que siguen la interfaz de Target.
def client_code(target)
  print target.request
end

puts 'Client: Solo puedo trabajar con objetos del tipo Target'
target = Target.new
client_code(target)
puts "\n\n"

adaptee = Adaptee.new
puts 'Client: No entiendo como obtener la información de Adaptee, es extraño'
# Se muestra la informacion de adaptee, a traves de su interfaz.
puts "Adaptee: #{adaptee.specific_request}"
puts "\n"

puts 'Client: Igual puedo ocupar el Adapter...'
# Creamos el adapter y le pasamos lo que debe ser adaptado, el adaptee.
adapter = Adapter.new(adaptee)
client_code(adapter)
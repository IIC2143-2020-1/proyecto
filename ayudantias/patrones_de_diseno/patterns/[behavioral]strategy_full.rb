# El navegador es el punto de entrada para el cliente y define metodos de interes para este.
class GPS

  # El navegador mantiene la referencia  hacia alguna estrategia.
  attr_writer :estrategia

  # Usualmente se puede inicializar la estrategia a traves del constructor.
  # Pero tambien es posible modificarla después, por eso se define el metodo setter estrategia.
  def initialize(estrategia)
    @estrategia = estrategia
  end

  # Cambiar de estrategia en runtime
  def estrategia=(estrategia)
    @estrategia = estrategia
  end

  # El navegador delega el trabajo a la estrategia, en vez de implementar multiples versiones
  # de un algoritmo el mismo.
  def construir_ruta(a, b)
    # ...

    puts 'Context: Definiendo ruta con la estrategia (no estoy seguro cual es)'
    @estrategia.algoritmo(a, b)

    # ...
  end
end

############################### Interfaz Estrategia #######################################

# La interfaz Estrategia declara operaciones comunes a todo tipo de estrategia.
# GPS la utiliza para llamar a un algoritmo definido por una estrategia en concreto, caminar o bicileta.

class Estrategia

  def algoritmo(_data)
    raise NotImplementedError, "#{self.class} no ha implementado el metodo '#{__method__}'"
  end
end

############################### Estrategias ###############################################

# Implementamos la estrategia Bicicleta.

class Bicicleta < Estrategia

  def algoritmo(a, b)
    puts "Bicicleta: #{a} hasta #{b}"
  end
end

# Implementamos la estrategia Caminar.

class Caminar < Estrategia

  def algoritmo(a, b)
    puts "Caminar: #{a} hasta #{b}"
  end
end

# IMPORTANTE: Podemos agregar tantas estrategias como tipo de rutas queramos construir.

############################### Cliente ###################################################

# Creamos las estrategias.
estrategia_caminar = Caminar.new
estrategia_bicicleta = Bicicleta.new

# Creamos el gps, con una estrategia por defecto, en este caso Caminar.
gps = GPS.new(estrategia_caminar)

# Construimos la ruta, aca gps no sabe cual estrategia ocupara, ya que como cliente le estoy asignando
# alguna en particular.
# Utilizamos caminar.
gps.construir_ruta("Pieza", "Cocina")

# Hacemos un cambio de estrategia, ya no queremos Caminar, necesitamos ir mas lejos.
# Por lo tanto, la estrategia Bicicleta tiene mas sentido, la asignamos.
gps.estrategia = estrategia_bicicleta

# Construimos la ruta.
gps.construir_ruta("Casa", "SJ")
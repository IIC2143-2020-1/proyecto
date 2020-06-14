# El observado posee un estado y notifica a los observadores cuando cambia.
class Observado
  # Por simplicidad el estado del observado se expone a los observadores con este atributo
  attr_accessor :estado

  def initialize
    @observadores = []
  end
  
  # Metodo para agregar observadores al observado
  def agregar(observador)
    puts "Observado: Tengo un nuevo observador #{observador.nombre}."
    @observadores << observador
  end

  def eliminar(observador)
    @observadores.delete(observador)
  end

  # Metodos para manejar a los observadores

  # Trigger an update in each subscriber.
  def notificar
    puts 'Observador: Notificando observadores...'
    @observadores.each { |observador| observador.actualizar(self) }
  end

  # La logica de la clase es la encargada de emitir las notificaciones cuando algo ocurre,
  # en este caso cada vez que el estado cambie, se notificara a los observadores.
  def logica
    puts "\nObservado: Estoy haciendo algo importante"
    # Con un random, podemos hacer reaccionar al ObservadorA o ObservadorB.
    # @estado = rand(0..10)

    # Con esto reaccionan ambos
    @estado = 0
    puts "\nObservado: mi estado cambio a #{@estado}"
    notificar
  end
end


############################################################################################
# Interfaz Observador

# The Observer interface declares the update method, used by subjects.
# La interfaz de observador declara el metodo actualizar, este es usado por el observado.
class Observador
  # Receive update from subject.
  def actualizar(_observado)
    raise NotImplementedError, "#{self.class} no tiene implementado el metodo '#{__method__}'"
  end
end

############################################################################################
# Codigo ObservadorA

# Creamos un Observador A, este implementa la interfaz (la hereda)
# En este caso reaccionara al objeto OBSERVADO, cuando el estado sea menor que 3.

class ObservadorA < Observador
  attr_accessor :nombre
  # @param [Subject] subject
  def initialize
    @nombre = 'ObservadorA'
  end

  def actualizar(observado)
    puts 'ObservadorA: reacciono al cambio de estado' if observado.estado == 3
  end
end

# ObservadorA es un suscriptor y reacciona a las actualizaciones hechas por el observado.

############################################################################################
# Codigo ObservadorB

# Creamos un Observador B, este implementa la interfaz (la hereda)
# En este caso reaccionara al objeto OBSERVADO, cuando el estado sea menor que 3.

class ObservadorB < Observador
  attr_accessor :nombre

  def initialize
    @nombre = 'ObservadorB'
  end

  def actualizar(observado)
    puts 'ObservadorB: reacciono al cambio de estado' if observado.estado == 4
  end
end

# ObservadorB es un suscriptor y reacciona a las actualizaciones hechas por el observado.

################################### Cliente ###########################################


observado = Observado.new

observador_a = ObservadorA.new
observador_b = ObservadorB.new

observado.agregar(observador_a)
observado.agregar(observador_b)

# Cambiamos el estado del observado, si el estado cambia a menor que 3,
# entonces el observador_a será notificado. Si es mayor que 3, se notifica a B.
observado.logica

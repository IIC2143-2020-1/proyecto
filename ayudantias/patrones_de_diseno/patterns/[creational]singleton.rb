# La clase Singleton define el metodo para generar la unica instancia que el cliente podra crear.
class Singleton
  @instance = new
  # Aseguro que new solo sea accesible desde la clase.
  private_class_method :new

  # Metodo de clase que devuelve las instancias.
  # self define un metodo de clase.
  # Nos permite poder utilizar este metodo para crear la instancia.
  def self.instance
    @instance
  end

  # Si se debe incluir alguna logica se puede implementar este metodo
  def some_business_logic
    # ...
  end
end

################################## Client ##################################


s1 = Singleton.instance
s2 = Singleton.instance

if s1.equal?(s2)
  print 'Singleton works, both variables contain the same instance.'
else
  print 'Singleton failed, variables contain different instances.'
end
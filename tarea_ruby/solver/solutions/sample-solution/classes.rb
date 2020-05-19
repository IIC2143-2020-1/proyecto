require_relative "getters"


class Persona

  attr_reader :id, :nombre, :edad

  def initialize(id, nombre, edad)
    @id = id.to_i
    @nombre = nombre
    @edad = edad.to_i
  end

  def cuarentena_por_edad
    @edad >= 65
  end

end


class Habitante < Persona

  attr_reader :sector

  def initialize(id, nombre, edad, sector)
    super(id, nombre, edad)
    @sector = sector
  end

  def self.generar(base_datasets, sectores)
    data = get_data("#{base_datasets}/habitantes.csv")
    habitantes = []
    data.each do |row|
      habitantes.push(Habitante.new(
        row[:id],
        row[:nombre],
        row[:edad],
        sectores[row[:sector].to_i]
      ))
    end
    habitantes
  end

  def cuarentena
    self.cuarentena_por_edad || @sector.hay_infectados
  end

end


class Pasajero < Persona

  attr_reader :vuelos, :paises

  def initialize(id, nombre, edad, vuelos, paises)
    super(id, nombre, edad)
    @vuelos = vuelos
    @paises = paises
  end

  def self.generar(base_datasets, vuelos, paises)
    data = get_data("#{base_datasets}/pasajeros.csv")
    pasajeros = []
    data.each do |row|
      vuelos_p = row[:vuelos].split(":").map{ |id| vuelos[id.to_i] }
      paises_p = row[:paises].split(":").map{ |id| paises[id.to_i] }

      # Pasajero
      pasajeros.push(Pasajero.new(
        row[:id],
        row[:nombre],
        row[:edad],
        vuelos_p,
        paises_p
      ))
    end
    pasajeros
  end

  def vuelos_recientes
    @vuelos.filter{ |vuelo| vuelo.dias_desde_vuelo <= 14 }
  end

  def vuelos_infectados
    @vuelos.filter{ |vuelo| vuelo.hay_infectados }
  end

  def paises_infectados
    @paises.filter{ |pais| pais.hay_infectados }
  end

  def cuarentena
    tiene_vuelos_inf = !self.vuelos_infectados.empty?
    tiene_paises_inf = !self.paises_infectados.empty?
    tiene_vuelos_rec = !self.vuelos_recientes.empty?
    self.cuarentena_por_edad || tiene_vuelos_inf || tiene_paises_inf || tiene_vuelos_rec
  end

end


class Sector

  attr_reader :id, :hay_infectados

  def initialize(id, hay_infectados)
    @id = id.to_i
    @hay_infectados = hay_infectados
  end

  def self.generar(base_datasets)
    data = get_data("#{base_datasets}/sectores.csv")
    sectores = {}
    data.each do |row|
      sectores[row[:id].to_i] = Sector.new(
        row[:id],
        row[:hay_infectados] == "true"
      )
    end
    sectores
  end

end


class Vuelo

  attr_reader :id, :hay_infectados, :dias_desde_vuelo

  def initialize(id, hay_infectados, dias_desde_vuelo)
    @id = id.to_i
    @hay_infectados = hay_infectados
    @dias_desde_vuelo = dias_desde_vuelo.to_i
  end

  def self.generar(base_datasets)
    data = get_data("#{base_datasets}/vuelos.csv")
    vuelos = {}
    data.each do |row|
      vuelos[row[:id].to_i] = Vuelo.new(
        row[:id],
        row[:hay_infectados] == "true",
        row[:dias_desde_vuelo]
      )
    end
    vuelos
  end

end


class Pais

  attr_reader :id, :nombre, :hay_infectados

  def initialize(id, nombre, hay_infectados)
    @id = id.to_i
    @nombre = nombre
    @hay_infectados = hay_infectados
  end

  def self.generar(base_datasets)
    data = get_data("#{base_datasets}/paises.csv")
    paises = {}
    data.each do |row|
      paises[row[:id].to_i] = Pais.new(
        row[:id],
        row[:nombre],
        row[:hay_infectados] == "true"
      )
    end
    paises
  end

end

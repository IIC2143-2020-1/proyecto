require_relative "classes"
require_relative "getters"


BASE_DATASETS = ARGV[0]
INSTRUCTIONS_FILE = ARGV[1]
LOG_FILE = ARGV[2]


class Main
  def initialize(base_datasets, instruction_file_dir, log_file_dir)
    @base_datasets = base_datasets
    @instructions = instruction_file_dir
    @logs = log_file_dir
    @sectores = Sector.generar(@base_datasets)
    @vuelos = Vuelo.generar(@base_datasets)
    @paises = Pais.generar(@base_datasets)
    self.generar_personas
  end

  def generar_personas
    @habitantes = Habitante.generar(@base_datasets, @sectores)
    @pasajeros = Pasajero.generar(@base_datasets, @vuelos, @paises)
  end

  def run()
    get_instructions(@instructions).each do |instr|
      self.log self.execute_instruction(instr)
    end
  end

  def log(data)
    File.open(@logs, "a") do |f|
      f.puts data
    end
  end

  def execute_instruction(instruction)
    if instruction == "pasajeros_en_cuarentena"
      self.pasajeros_en_cuarentena
    elsif instruction == "habitantes_en_cuarentena"
      self.habitantes_en_cuarentena
    elsif instruction == "personas_en_cuarentena"
      self.personas_en_cuarentena
    elsif instruction == "personas_en_edad_de_riesgo"
      self.personas_en_edad_de_riesgo
    elsif instruction == "pasajeros_de_paises_infectados"
      self.pasajeros_de_paises_infectados
    elsif instruction == "pasajeros_de_vuelos_infectados"
      self.pasajeros_de_vuelos_infectados
    end
  end

  def pasajeros_en_cuarentena
    respuesta = ["*** COMIENZO PASAJEROS EN CUARENTENA ***"]
    @pasajeros.each do |pas|
      if pas.cuarentena
        respuesta.push(
          "#{pas.nombre}: #{pas.edad}. " \
          "#{pas.paises.map{ |x| x.nombre }.join(' - ')}. #{pas.vuelos.length}"
        )
      end
    end
    respuesta.push("*** FIN PASAJEROS EN CUARENTENA ***")
    respuesta.join("\n")
  end

  def habitantes_en_cuarentena
    respuesta = ["*** COMIENZO HABITANTES EN CUARENTENA ***"]
    @habitantes.each do |hab|
      if hab.cuarentena
        respuesta.push(
          "#{hab.nombre}: #{hab.edad}. Sector #{hab.sector.id}"
        )
      end
    end
    respuesta.push("*** FIN HABITANTES EN CUARENTENA ***")
  end

  def personas_en_cuarentena
    respuesta = ["*** COMIENZO PERSONAS EN CUARENTENA ***"]
    @habitantes.each do |hab|
      if hab.cuarentena
        respuesta.push(
          "#{hab.nombre}: #{hab.edad}. Habitante"
        )
      end
    end
    @pasajeros.each do |pas|
      if pas.cuarentena
        respuesta.push(
          "#{pas.nombre}: #{pas.edad}. Pasajero"
        )
      end
    end
    respuesta.push("*** FIN PERSONAS EN CUARENTENA ***")
    respuesta.join("\n")
  end

  def personas_en_edad_de_riesgo
    respuesta = ["*** COMIENZO PERSONAS EN EDAD DE RIESGO ***"]
    @habitantes.each do |hab|
      if hab.cuarentena_por_edad
        respuesta.push(
          "#{hab.nombre}: #{hab.edad}. Habitante"
        )
      end
    end
    @pasajeros.each do |pas|
      if pas.cuarentena_por_edad
        respuesta.push(
          "#{pas.nombre}: #{pas.edad}. Pasajero"
        )
      end
    end
    respuesta.push("*** FIN PERSONAS EN EDAD DE RIESGO ***")
    respuesta.join("\n")
  end

  def pasajeros_de_paises_infectados
    respuesta = ["*** COMIENZO PASAJEROS DE PAISES INFECTADOS ***"]
    @pasajeros.each do |pas|
      if !pas.paises_infectados.empty?
        respuesta.push(
          "#{pas.nombre}: #{pas.edad}. " \
          "#{pas.paises_infectados.map{ |x| x.nombre }.join(' - ')}"
        )
      end
    end
    respuesta.push("*** FIN PASAJEROS DE PAISES INFECTADOS ***")
    respuesta.join("\n")
  end

  def pasajeros_de_vuelos_infectados
    respuesta = ["*** COMIENZO PASAJEROS DE VUELOS INFECTADOS ***"]
    @pasajeros.each do |pas|
      if !pas.vuelos_infectados.empty?
        respuesta.push(
          "#{pas.nombre}: #{pas.edad}. " \
          "#{pas.vuelos_infectados.map{ |x| x.id }.join(' - ')}"
        )
      end
    end
    respuesta.push("*** FIN PASAJEROS DE VUELOS INFECTADOS ***")
    respuesta.join("\n")
  end

end


main = Main.new(BASE_DATASETS, INSTRUCTIONS_FILE, LOG_FILE)
main.run()

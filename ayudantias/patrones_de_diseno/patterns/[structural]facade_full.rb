### Conjunto de clases de un framework 3rd-party para conversion de videos. No controlamos este codigo.
class VideoFile
  def execution(filename, format)
    puts "\n"
    puts "Executing: VideoFile"
    puts "Video file created: #{filename}.#{format}"
    puts "\n"
  end
end

class OggCompressionCodec
  def execution
    puts "Executing: OggCompressionCodec"
    puts "\n"
  end
end

class MPEG4CompressionCodec
  def execution
    puts "Executing: MPEG4CompressionCodec"
    puts "\n"
  end
end

# Creamos una fachada, VideoConverter para ocultar la complejidad del 3rd-party, detras de la interfaz
# esta ejecuta distintas funciones a traves de un unico metodo para el cliente.
class VideoConverter
  def initialize(videofile, oggCompressionCodec, mpeg4_compression)
    @videofile = videofile
    @oggCompressionCodec = oggCompressionCodec
    @mpeg4_compression = mpeg4_compression
  
  end
  def convert(filename, format)
    @videofile.execution(filename, format)
    @oggCompressionCodec.execution
    @mpeg4_compression.execution
  end
end

#################################### Cliente ################################################

video_converter = VideoConverter.new(VideoFile.new, OggCompressionCodec.new, MPEG4CompressionCodec.new)

video_converter.convert("clase_patrones", "mp4")

video_converter.convert("ayudantia_pasada", "mp4")
require "csv"


def get_data(filename)
  CSV.read(
    filename,
    :headers => :first_row,
    :header_converters => :symbol
  ).map(&:to_h)
end

def get_instructions(instruction_file_dir)
  File.readlines(instruction_file_dir).map{ |line| line.strip }
end

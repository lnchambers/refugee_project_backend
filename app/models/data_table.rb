require 'fastest-csv'
require_relative 'observation'

class DataTable

  attr_accessor :observations, :variables

  def initialize(opts = {})
    @file = opts[:file]
    @label_index = opts[:label_index]
    @observations = FastestCSV.read(@file)
    @variables = @observations[0]
    @observations.shift

    if @file.nil? == false
      @observations.map! do |row|
        Observation.new(row[0..-2], @label_index)
      end
    end
  end

  def persist(file)
    File.open(file, 'w+'){ |f| f << Marshal.dump(self) }
  end

  def self.load(file)
    Marshal.load(File.binread(file))
  end

  def sample
    @observations.sample
  end
end

# frozen_string_literal: true

class MapReduceReader
  def initialize(mapper_class: SailingsMapper, file_path: "response.json")
    @mapper_class = mapper_class
    @file_path = file_path
  end

  def call
    mapper = mapper_class.new(JSON.parse(File.read(file_path), symbolize_names: true))
    mapper.call
  end

  private

  attr_reader :mapper_class, :file_path
end

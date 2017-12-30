require 'json'
require 'active_support'
require 'activerecord-import'
require './lib/json_search'

class JsonIndex
  attr_reader :files

  JSON_FILES_PATH = './json_files/*.json'
  VALUES_SEPARATOR = '||'

  def initialize
    @files = Dir[JSON_FILES_PATH].map do |file_path|

      unless is_json_type(file_path)
        raise "Invalid File - #{file_path}. It should be JSON type."
      end

      { file: File.read(file_path),
        path: file_path,
        name: json_file_name(file_path) }
    end
  end

  def index_files
    puts 'Indexing ...'

    # Bulk import into the DB file wise.
    self.files.each do |file_hash|
      import_data = get_index_data(file_hash)
      JsonSearch.import! import_data, on_duplicate_key_ignore: true
    end

    puts 'Done.'
  end

  def get_index_data(file_hash)
    index_data = []

    begin
      file_data = JSON.parse(file_hash[:file])
    rescue
      raise "Invalid JSON content in the file - #{file_hash[:path]}"
    end

    file_name = file_hash[:name]

    # JSON file make contain arrays as of JSON objects. So handling that case.
    if file_data.is_a?(Array)
      file_data.each { |_json_data| index_data << get_json_search_object(_json_data, file_name) }
    else
      index_data << get_json_search_object(file_data, file_name)
    end

    index_data
  end

  def is_json_type(file)
    '.json' == File.extname(file)
  end

  def json_file_name(file)
    File.basename(file).gsub(/\.json/, '')
  end

  # Returns JSONSearch object having all the field to be bulk imported into the DB
  def get_json_search_object(json_data, file_name)
    values_string = VALUES_SEPARATOR

    parse_nested_values(json_data.values).uniq.each do |value|
      next if !value || value.empty?

      values_string += "#{value}#{VALUES_SEPARATOR}"
    end

    JsonSearch.new(search_values: values_string, json_data: json_data, json_data_type: file_name)
  end

  # Returns nested array / hash values as plan array of strings.
  def parse_nested_values(values)
    parsed_values = []

    if values.is_a?(Hash)
      parsed_values |= parse_nested_values(values.values)
    elsif values.is_a?(Array)
      values.each do |value|
        parsed_values |= parse_nested_values(value)
      end
    else
      parsed_values |= [values.to_s]
    end

    parsed_values
  end
end

require 'json'
require './lib/json_search'

class JsonIndex
  attr_reader :files

  JSON_FILES_PATH = './json_files/*.json'

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

  def is_json_type(file)
    '.json' == File.extname(file)
  end

  def json_file_name(file)
    File.basename(file).gsub(/\.json/, '')
  end
end

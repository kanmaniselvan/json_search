require 'json'
require './lib/json_search'

class JsonIndex
  attr_reader :files

  JSON_FILES_PATH = './json_files/*.json'

  def initialize
    @files = Dir[JSON_FILES_PATH].each { |file| File.open(file) }
  end
end

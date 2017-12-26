require './db/connection'
require 'activerecord-import'

class JsonSearch < ActiveRecord::Base
  validates :search_values, :json_data, :json_data_type, presence: true
  validates_uniqueness_of :search_values
end

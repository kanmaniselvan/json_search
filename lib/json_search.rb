require './db/connection'

class JsonSearch < ActiveRecord::Base
  validates :search_values, :json_data, :json_data_type, presence: true
  validates_uniqueness_of :search_values

  def self.search(keyword)
    JsonSearch.where('search_values like ?', "%#{get_separated_joined_keyword(keyword)}%")
  end

  def self.get_separated_joined_keyword(keyword)
    "#{::JsonIndex::VALUES_SEPARATOR}#{keyword}#{::JsonIndex::VALUES_SEPARATOR}"
  end
end

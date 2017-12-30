require './db/connection'
require './lib/json_helpers/search'
require './lib/json_index'

class JsonSearch < ActiveRecord::Base
  extend JsonHelpers::Search

  validates :search_values, :json_data, :json_data_type, presence: true
  validates_uniqueness_of :search_values

  def self.search(keyword)
    results = JsonSearch.where('LOWER(search_values) like ?', "%#{get_separator_joined_keyword(keyword)}%")
    results.empty? ? 'No results.' : get_human_readable_format(results)
  end

  def self.get_separator_joined_keyword(keyword)
    "#{::JsonIndex::VALUES_SEPARATOR}#{keyword}#{::JsonIndex::VALUES_SEPARATOR}"
  end

  def self.get_human_readable_format(results)
    output = "\n"

    results.group_by(&:json_data_type).map do |json_data_type, json_search_records|
      formatted_json_date_type = " #{json_data_type.upcase} (#{json_search_records.size}) "
      output += "#{get_group_separator(formatted_json_date_type)}\n"
      output += readable_json_data(json_search_records)
      output += "#{get_group_separator('-')}\n\n"
    end

    output
  end

  def self.readable_json_data(json_search_record)
    output = "\n"

    json_search_record.each_with_index do |json_search, index|
      output += "\n#{get_result_number(index+1)}\n\n"

      json_search.json_data.each do |key, value|
        output += "#{get_sanitized_key(key)}: #{get_readable_nested_values(value).gsub(/^\n\s+/, '')}\n"
      end
    end

    output += "\n"

    output
  end
end

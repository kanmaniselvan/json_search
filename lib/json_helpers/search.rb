module JsonHelpers
  module Search
    def get_sanitized_key(key, perform_ljust=true)
      key_string = key.tr('_', ' ').capitalize.strip
      perform_ljust ? key_string.ljust(30) : key_string
    end

    def get_group_separator(string)
      string.center(100, '-')
    end

    def get_result_number(index)
      index_string = " #{index} "
      index_string.center(30, '*')
    end

    def get_readable_nested_values(value, intend_space="")
      value_string = ""

      if value.is_a?(Hash)
        intend_space += "     "

        value.each do |key, _value|
          value_string += "\n#{intend_space}#{get_sanitized_key(key, false)} => #{get_readable_nested_values(_value, intend_space)}"
        end
      elsif value.is_a?(Array)
        value_string += value.join(', ')
      else
        value_string += value.to_s
      end

      value_string
    end
  end
end

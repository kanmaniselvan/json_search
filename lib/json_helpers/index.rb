module JsonHelpers
  module Index
    def is_json_type(file)
      '.json' == File.extname(file)
    end

    def json_file_name(file)
      File.basename(file).gsub(/\.json/, '')
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
end

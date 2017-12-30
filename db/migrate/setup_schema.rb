require './db/connection'

if ActiveRecord::Base.connection.table_exists?(:json_searches)
  ActiveRecord::Base.connection.drop_table :json_searches
end

ActiveRecord::Schema.define do
  create_table :json_searches do |t|
    t.text :search_values, null: false
    t.json :json_data, null: false
    t.string :json_data_type, null: false

    t.timestamps null: false

    t.index :search_values, unique: true
  end
end

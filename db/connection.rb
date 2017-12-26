require 'active_record'

# Change the following to reflect your database settings
ActiveRecord::Base.establish_connection(
    adapter:  'postgresql',
    host:     'localhost',
    database: 'json_search',
    username: 'postgres',
    password: 'postgres'
)

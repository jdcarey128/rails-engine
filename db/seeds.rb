require 'csv'

cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d rails-engine_development db/data/rails-engine-development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

def cents_to_dollars(cents)
  (cents.to_i / 100) + ((cents.to_f % 100) * 0.01 )
end

def run_reset_keys 
  ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end
end

items = []
CSV.foreach('db/data/items.csv', headers: true, header_converters: :symbol) do |row|
  row = row.to_h 
  row[:unit_price] = cents_to_dollars(row[:unit_price])
  items << row 
end

Item.import items, validate: true 

run_reset_keys

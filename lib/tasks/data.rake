require 'csv'

namespace :data do 
  desc "Import Data"
  task import: ["reset_db", "load_pg_files", "load_csv", "reset_keys"] do 
    puts "The database is ready to go!"
  end

  task :reset_db do 
    `rails db:{drop,create,migrate}`
  end

  task :load_pg_files do 
    cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d rails-engine_development db/data/rails-engine-development.pgdump"
    puts "Loading PostgreSQL Data dump into local database with command:"
    puts cmd
    system(cmd)
  end
  
  task load_csv: :environment do 
    puts "Loading CSV data..."
    def cents_to_dollars(cents)
      (cents.to_i / 100) + ((cents.to_f % 100) * 0.01 )
    end
    items = []
    CSV.foreach('db/data/items.csv', headers: true, header_converters: :symbol) do |row|
      row = row.to_h 
      row[:unit_price] = cents_to_dollars(row[:unit_price])
      items << row 
    end
    Item.import items, validate: true 
  end
  
  task :reset_keys do 
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end

end

namespace :db do
  namespace :fixtures do  

    SKIP_TABLES = %w[ schema_info schema_migrations sessions entries open_id_authentication_associations open_id_authentication_nonces feed_items]

    desc 'Create YAML test fixtures from data in an existing database. Defaults to development database. Set RAILS_ENV to override.'
    task :extract => :environment do
      fixture_path = "#{RAILS_ROOT}/tmp/fixtures"
      mkdir_p fixture_path

      sql = "SELECT * from %s"
      ActiveRecord::Base.establish_connection
      (ActiveRecord::Base.connection.tables - SKIP_TABLES).each do |table_name|
        puts "flattening #{table_name}"
        i = "000"

        length = ActiveRecord::Base.connection.select_value("select count(*) from #{table_name}")
        puts "#{table_name}: #{length} records total"

        File.open("#{fixture_path}/#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.to_yaml
        end
      end
    end

    task :import => :environment do
      require 'pp'

      puts "importing"
      # skip_tables += %w{
      # }

      ActiveRecord::Base.establish_connection

      tables = (ActiveRecord::Base.connection.tables - SKIP_TABLES)
      # tables = %w{users}

      tables.each do |table_name|
        puts "loading #{table_name}"
        model = table_name.singularize.camelize.constantize
        model.delete_all

        puts "model: #{model}"
        fixture = YAML.load_file("#{RAILS_ROOT}/tmp/fixtures/#{table_name}.yml")
        
        fixture.keys.sort.each do |key|
          begin
            record = fixture[key]
            case table_name
            when 'facets'
              record['info'] = YAML.load(record['info'])
            when 'meetings'
              record['date'] = DateTime.parse(record['date'])
            end

            m = model.new(record)
            m.id = record['id']
            m.save!
          rescue
            puts "error importing #{key}"
            pp record
            raise $!
          end
        end
      end
    end
  end
end

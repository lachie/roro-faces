require 'pp'
namespace :db do
  task :postgres => :environment do
    e = ActiveRecord::Base.configurations[Rails.env]
    ENV['PGUSER']     = e['username']
    ENV['PGHOST']     = e['host']
    ENV['PGPASSWORD'] = e['password']
    @database = e['database']
  end

  task :import => :postgres do
    file = Dir['faces.*.sql.bz2'].sort.last

    sh "dropdb #{@database}"
    sh "createdb #{@database}"
    sh "bzcat #{file} | psql #{@database}"

    #ENV['PGUSER']
  end
end

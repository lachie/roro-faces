
set :dump_time, Time.now.strftime('%Y%m%d_%H%M%S')

desc "get data"
task :get_data, :role => :app do
  set :dumped, "faces.#{dump_time}.sql"
  
  run "cd /tmp && pg_dump faces > #{dumped} && bzip2 #{dumped}", :env => {'PGUSER' => 'faces', 'PGPASSWORD' => 'faces', 'PGHOST' => 'localhost'}
  
  get "/tmp/#{dumped}.bz2", "./#{dumped}.bz2"
  
  run "rm /tmp/#{dumped}.bz2"
end

task :get_mugshots do
  set :mugs  , "faces.#{dump_time}.tar.bz2"
  run "cd /tmp && tar jcvf /tmp/#{mugs} #{shared_path}/public/mugshots"
  get "/tmp/#{mugs}"      , "./#{mugs}"
  run "rm  /tmp/#{mugs}"
end

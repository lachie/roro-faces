desc "get data"
task :get_data, :role => :app do
  now = Time.now.strftime('%Y%m%d_%H%M%S')
  
  set :dumped, "faces.#{now}.sql"
  set :mugs  , "faces.#{now}.tar.bz2"
  
  run "cd /tmp && mysqldump -u root faces > #{dumped} && bzip2 #{dumped}"
  run "cd /tmp && tar jcvf /tmp/#{mugs} #{shared_path}/public/mugshots"
  
  get "/tmp/#{dumped}.bz2", "./#{dumped}.bz2"
  get "/tmp/#{mugs}"      , "./#{mugs}"
  
  run "rm /tmp/#{dumped}.bz2 /tmp/#{mugs}"
end

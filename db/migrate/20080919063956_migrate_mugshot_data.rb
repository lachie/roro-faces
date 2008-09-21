class MigrateMugshotData < ActiveRecord::Migration
  def self.up
    User.reset_column_information    
    
    puts "hooray"
    
    User.all.each do |user|
      puts "user: #{user.name}"
      
      begin
        m = Mugshot.find(user.mugshot_id)
      rescue ActiveRecord::RecordNotFound
        puts "warning, #{user.name} (#{user.email}) has a hanging mugshot reference, skipping"
        next
      end
      
      path = File.join(RAILS_ROOT, 'public', 'old_mugshots', user.mugshot_id.to_s, m.filename)
      
      puts "path: #{path}"
      
      puts "OK" if File.exist?(path)
      
      user.mugshot = File.open(path)
      user.save!
    end
    
    raise "undo..."
  end

  def self.down
  end
end
